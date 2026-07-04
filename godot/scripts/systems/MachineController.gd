extends Node2D

signal brew_completed(success: bool, purity: float)

# ─── Game State ───────────────────────────────────────────────────────────────
var ignition: bool = false
var mixer_speed: int = 0        # 0=off 1=slow 2=med 3=fast
var heat_level: float = 0.5     # 0-1 from temperature lever
var vent_open: bool = false
var filter_index: int = 5       # 0=RUBY 1=AZURE 2=VERDANT 3=AMBER 4=ARCANE 5=CLEAR
var catalyst_cooldown: float = 0.0
var used_catalyst: bool = false

var temperature: float = 20.0   # °C
var pressure: float = 0.0       # PSI
var purity: float = 100.0       # %
var brew_time_in_range: float = 0.0
var game_state: String = "IDLE" # IDLE BREWING SUCCESS FAILURE

var current_recipe: int = 0

# ─── Filter names/colors (matches prototype) ──────────────────────────────────
const FILTER_NAMES := ["RUBY", "AZURE", "VERDANT", "AMBER", "ARCANE", "CLEAR"]
const FILTER_COLORS := [
	Color(0.78, 0.3, 0.23), Color(0.42, 0.63, 1.0), Color(0.25, 0.65, 0.59),
	Color(0.78, 0.63, 0.23), Color(0.48, 0.36, 0.65), Color(0.9, 0.9, 0.9)
]

# ─── UI refs (set in _build_ui) ───────────────────────────────────────────────
var _temp_gauge  # GaugeAnimator Control
var _press_gauge  # GaugeAnimator Control
var _chamber_fill: ColorRect
var _chamber_bubbles: Array[ColorRect] = []
var _status_label: Label
var _recipe_label: Label
var _temp_readout: Label
var _press_readout: Label
var _purity_readout: Label
var _brew_progress: ProgressBar
var _ignition_btn: Button
var _mixer_btns: Array[Button] = []
var _catalyst_btn: Button
var _relief_btn: Button
var _vent_slider: HSlider
var _filter_prev_btn: Button
var _filter_next_btn: Button
var _heat_slider: HSlider
var _filter_label: Label
var _filter_display: ColorRect

# ─── Lifecycle ────────────────────────────────────────────────────────────────
func _ready() -> void:
	_build_ui()
	InputManager.button_pressed.connect(_on_button_pressed)
	InputManager.lever_changed.connect(_on_lever_changed)
	_update_recipe_display()

func _process(delta: float) -> void:
	if game_state in ["SUCCESS", "FAILURE"]:
		return
	catalyst_cooldown = max(0.0, catalyst_cooldown - delta)
	_simulate_physics(delta)
	_check_game_state()
	_update_ui()

# ─── Input handlers ───────────────────────────────────────────────────────────
func _on_button_pressed(id: String) -> void:
	match id:
		"ignition":   _toggle_ignition()
		"mixer_1":    _set_mixer(1)
		"mixer_2":    _set_mixer(2)
		"mixer_3":    _set_mixer(3)
		"catalyst":   _trigger_catalyst()
		"relief":     _trigger_relief()
		"filter_next": _cycle_filter(1)
		"filter_prev": _cycle_filter(-1)

func _on_lever_changed(id: String, value: float) -> void:
	match id:
		"heat":  heat_level = value
		"vent":  vent_open = value > 0.5

# ─── Button actions ───────────────────────────────────────────────────────────
func _toggle_ignition() -> void:
	ignition = not ignition
	_ignition_btn.modulate = Color(1.5, 0.5, 0.3) if ignition else Color(1, 1, 1)
	if ignition and game_state == "IDLE":
		game_state = "BREWING"

func _set_mixer(speed: int) -> void:
	mixer_speed = speed if mixer_speed != speed else 0
	for i in range(_mixer_btns.size()):
		_mixer_btns[i].modulate = Color(1.2, 1.0, 0.3) if (i + 1) == mixer_speed else Color(1, 1, 1)

func _trigger_catalyst() -> void:
	if catalyst_cooldown > 0.0:
		return
	catalyst_cooldown = 15.0
	used_catalyst = true
	purity = min(100.0, purity + 10.0)
	_catalyst_btn.modulate = Color(0.8, 0.5, 1.5)
	await get_tree().create_timer(0.3).timeout
	if is_instance_valid(_catalyst_btn):
		_catalyst_btn.modulate = Color(1, 1, 1)

func _trigger_relief() -> void:
	pressure = max(0.0, pressure - 2.0)

func _cycle_filter(direction: int) -> void:
	filter_index = wrapi(filter_index + direction, 0, FILTER_NAMES.size())
	_filter_label.text = FILTER_NAMES[filter_index]
	_filter_display.color = FILTER_COLORS[filter_index]

func reset() -> void:
	ignition = false
	mixer_speed = 0
	heat_level = 0.5
	vent_open = false
	filter_index = 5
	catalyst_cooldown = 0.0
	used_catalyst = false
	temperature = 20.0
	pressure = 0.0
	purity = 100.0
	brew_time_in_range = 0.0
	game_state = "IDLE"
	_ignition_btn.modulate = Color(1, 1, 1)
	for btn in _mixer_btns:
		btn.modulate = Color(1, 1, 1)
	_catalyst_btn.modulate = Color(1, 1, 1)
	_heat_slider.value = 0.5
	if _vent_slider:
		_vent_slider.value = 0.0
	_filter_label.text = FILTER_NAMES[filter_index]
	_filter_display.color = FILTER_COLORS[filter_index]
	_update_recipe_display()

func set_controls_enabled(enabled: bool) -> void:
	_ignition_btn.disabled = not enabled
	for btn in _mixer_btns:
		btn.disabled = not enabled
	_catalyst_btn.disabled = not enabled
	_relief_btn.disabled = not enabled
	_heat_slider.editable = enabled
	if _vent_slider:
		_vent_slider.editable = enabled
	if _filter_prev_btn:
		_filter_prev_btn.disabled = not enabled
	if _filter_next_btn:
		_filter_next_btn.disabled = not enabled

# ─── Physics simulation ───────────────────────────────────────────────────────
func _simulate_physics(delta: float) -> void:
	# Temperature
	var target_temp := heat_level * Constants.MAX_TEMP if ignition else 20.0
	var heat_rate := 25.0 if ignition else 8.0
	temperature = move_toward(temperature, target_temp, heat_rate * delta)
	temperature = clamp(temperature, Constants.MIN_TEMP, Constants.MAX_TEMP)

	# Pressure from mixer
	var pressure_gain := [0.0, 0.5, 1.0, 2.0][mixer_speed]
	pressure_gain += temperature / 100.0 * 0.3  # heat adds pressure
	var pressure_loss := 0.15                    # natural bleed
	if vent_open:
		pressure_loss += 3.0
	pressure += (pressure_gain - pressure_loss) * delta
	pressure = clamp(pressure, 0.0, Constants.MAX_PRESSURE)

	# Purity degrades when out of range
	var recipe := ChemistrySystem.RECIPES[current_recipe]
	var temp_ok := temperature >= recipe["min_temp"] and temperature <= recipe["max_temp"]
	var press_ok := pressure >= recipe["min_pressure"] and pressure <= recipe["max_pressure"]
	if game_state == "BREWING":
		if not temp_ok:
			purity -= 8.0 * delta
		if not press_ok:
			purity -= 4.0 * delta
		if temp_ok and press_ok:
			brew_time_in_range += delta
		purity = clamp(purity, 0.0, 100.0)

func _check_game_state() -> void:
	if game_state != "BREWING":
		return
	if purity <= 0.0 or pressure >= Constants.MAX_PRESSURE:
		game_state = "FAILURE"
		brew_completed.emit(false, purity)
		return
	var result := ChemistrySystem.evaluate_brew(brew_time_in_range, purity, used_catalyst, filter_index, current_recipe)
	if result["success"]:
		game_state = "SUCCESS"
		brew_completed.emit(true, purity)

# ─── UI update ────────────────────────────────────────────────────────────────
func _update_ui() -> void:
	_temp_gauge.set_value(temperature)
	_press_gauge.set_value(pressure)
	_temp_readout.text = "TEMP  %.0f°C" % temperature
	_press_readout.text = "PRESS %.1f PSI" % pressure
	_purity_readout.text = "PURITY %.0f%%" % purity

	var recipe := ChemistrySystem.RECIPES[current_recipe]
	var req_time: float = recipe["brew_time"]
	_brew_progress.value = brew_time_in_range / req_time * 100.0

	# Chamber liquid color shifts with temperature and filter
	var heat_t := (temperature - Constants.MIN_TEMP) / (Constants.MAX_TEMP - Constants.MIN_TEMP)
	var base_color := FILTER_COLORS[filter_index]
	_chamber_fill.color = base_color.lerp(Color(1.0, 0.3, 0.1), heat_t * 0.5)

	# Status indicator
	match game_state:
		"IDLE":    _status_label.text = "AWAITING IGNITION"
		"BREWING": _status_label.text = "BREWING... %.0fs / %.0fs" % [brew_time_in_range, req_time]
		"SUCCESS": _status_label.text = "SUCCESS"
		"FAILURE": _status_label.text = "FAILURE"

	# Catalyst button dims during cooldown
	if catalyst_cooldown > 0.0:
		_catalyst_btn.text = "CATALYST (%.0fs)" % catalyst_cooldown
		_catalyst_btn.modulate = Color(0.6, 0.6, 0.6)
	else:
		_catalyst_btn.text = "CATALYST ⚡"
		if _catalyst_btn.modulate != Color(0.8, 0.5, 1.5):
			_catalyst_btn.modulate = Color(1, 1, 1)

func _update_recipe_display() -> void:
	var recipe := ChemistrySystem.RECIPES[current_recipe]
	_recipe_label.text = (
		"[%s]\n%s\nTemp: %.0f–%.0f°C\nPress: %.1f–%.1f PSI\nTime: %.0fs" % [
			recipe["name"], recipe["desc"],
			recipe["min_temp"], recipe["max_temp"],
			recipe["min_pressure"], recipe["max_pressure"],
			recipe["brew_time"]
		]
	)

# ─── UI construction ──────────────────────────────────────────────────────────
func _build_ui() -> void:
	var W := 1280.0
	var H := 720.0

	# Background
	var bg := ColorRect.new()
	bg.color = Constants.DEEP_TEAL
	bg.size = Vector2(W, H)
	add_child(bg)

	# Title
	var title := Label.new()
	title.text = "✦ ALCHEMICAL APPARATUS ✦"
	title.add_theme_font_size_override("font_size", 22)
	title.add_theme_color_override("font_color", Constants.BRASS_GOLD)
	title.position = Vector2(W / 2 - 200, 12)
	add_child(title)

	# ── Left column: gauges ─────────────────────────────────────────────────
	var gauge_x := 40.0
	var gauge_y := 60.0

	# Temperature gauge (reuses GaugeAnimator, but we build a thermometer variant inline)
	var temp_gauge_script := load("res://scripts/controllers/GaugeAnimator.gd")
	_temp_gauge = Control.new()
	_temp_gauge.set_script(temp_gauge_script)
	_temp_gauge.position = Vector2(gauge_x, gauge_y)
	_temp_gauge.size = Vector2(160, 160)
	_temp_gauge.set("min_value", Constants.MIN_TEMP)
	_temp_gauge.set("max_value", Constants.MAX_TEMP)
	_temp_gauge.set("warning_threshold", 80.0)
	_temp_gauge.set("danger_threshold", 92.0)
	_temp_gauge.set("unit_label", "°C")
	add_child(_temp_gauge)

	var temp_title := Label.new()
	temp_title.text = "TEMPERATURE"
	temp_title.add_theme_font_size_override("font_size", 10)
	temp_title.add_theme_color_override("font_color", Constants.BRASS_GOLD)
	temp_title.position = Vector2(gauge_x + 30, gauge_y + 162)
	add_child(temp_title)

	# Pressure gauge
	var press_gauge_script := load("res://scripts/controllers/GaugeAnimator.gd")
	_press_gauge = Control.new()
	_press_gauge.set_script(press_gauge_script)
	_press_gauge.position = Vector2(gauge_x, gauge_y + 200)
	_press_gauge.size = Vector2(160, 160)
	_press_gauge.set("min_value", 0.0)
	_press_gauge.set("max_value", Constants.MAX_PRESSURE)
	_press_gauge.set("warning_threshold", Constants.WARNING_PRESSURE)
	_press_gauge.set("danger_threshold", Constants.DANGER_PRESSURE)
	_press_gauge.set("unit_label", "PSI")
	add_child(_press_gauge)

	var press_title := Label.new()
	press_title.text = "PRESSURE"
	press_title.add_theme_font_size_override("font_size", 10)
	press_title.add_theme_color_override("font_color", Constants.BRASS_GOLD)
	press_title.position = Vector2(gauge_x + 40, gauge_y + 362)
	add_child(press_title)

	# ── Center: chamber ─────────────────────────────────────────────────────
	var chamber_x := 240.0
	var chamber_y := 60.0
	var chamber_w := 580.0
	var chamber_h := 380.0

	var chamber_border := ColorRect.new()
	chamber_border.position = Vector2(chamber_x - 4, chamber_y - 4)
	chamber_border.size = Vector2(chamber_w + 8, chamber_h + 8)
	chamber_border.color = Constants.BRASS_GOLD
	add_child(chamber_border)

	_chamber_fill = ColorRect.new()
	_chamber_fill.position = Vector2(chamber_x, chamber_y)
	_chamber_fill.size = Vector2(chamber_w, chamber_h)
	_chamber_fill.color = FILTER_COLORS[filter_index]
	add_child(_chamber_fill)

	# Chamber label
	var chamber_lbl := Label.new()
	chamber_lbl.text = "MAIN CHAMBER"
	chamber_lbl.add_theme_font_size_override("font_size", 10)
	chamber_lbl.add_theme_color_override("font_color", Color(0.6, 0.9, 0.7, 0.5))
	chamber_lbl.position = Vector2(chamber_x + chamber_w / 2 - 45, chamber_y + 8)
	add_child(chamber_lbl)

	# Filter display strip
	_filter_display = ColorRect.new()
	_filter_display.position = Vector2(chamber_x, chamber_y + chamber_h - 30)
	_filter_display.size = Vector2(chamber_w, 30)
	_filter_display.color = FILTER_COLORS[filter_index]
	add_child(_filter_display)

	_filter_label = Label.new()
	_filter_label.text = FILTER_NAMES[filter_index]
	_filter_label.add_theme_font_size_override("font_size", 11)
	_filter_label.add_theme_color_override("font_color", Color(0.1, 0.1, 0.1))
	_filter_label.position = Vector2(chamber_x + chamber_w / 2 - 25, chamber_y + chamber_h - 26)
	add_child(_filter_label)

	# ── Right column: readout ───────────────────────────────────────────────
	var ro_x := 840.0
	var ro_y := 60.0
	var readout_panel := ColorRect.new()
	readout_panel.position = Vector2(ro_x, ro_y)
	readout_panel.size = Vector2(200, 380)
	readout_panel.color = Color(0.08, 0.12, 0.15)
	add_child(readout_panel)

	var ro_title := Label.new()
	ro_title.text = "— READOUT —"
	ro_title.add_theme_font_size_override("font_size", 11)
	ro_title.add_theme_color_override("font_color", Constants.BRASS_GOLD)
	ro_title.position = Vector2(ro_x + 30, ro_y + 10)
	add_child(ro_title)

	_temp_readout = Label.new()
	_temp_readout.add_theme_font_size_override("font_size", 12)
	_temp_readout.add_theme_color_override("font_color", Color(0.4, 0.8, 1.0))
	_temp_readout.position = Vector2(ro_x + 12, ro_y + 40)
	add_child(_temp_readout)

	_press_readout = Label.new()
	_press_readout.add_theme_font_size_override("font_size", 12)
	_press_readout.add_theme_color_override("font_color", Color(1.0, 0.7, 0.3))
	_press_readout.position = Vector2(ro_x + 12, ro_y + 64)
	add_child(_press_readout)

	_purity_readout = Label.new()
	_purity_readout.add_theme_font_size_override("font_size", 12)
	_purity_readout.add_theme_color_override("font_color", Color(0.6, 1.0, 0.5))
	_purity_readout.position = Vector2(ro_x + 12, ro_y + 88)
	add_child(_purity_readout)

	var brew_lbl := Label.new()
	brew_lbl.text = "BREW PROGRESS"
	brew_lbl.add_theme_font_size_override("font_size", 10)
	brew_lbl.add_theme_color_override("font_color", Constants.BRASS_GOLD)
	brew_lbl.position = Vector2(ro_x + 12, ro_y + 120)
	add_child(brew_lbl)

	_brew_progress = ProgressBar.new()
	_brew_progress.position = Vector2(ro_x + 12, ro_y + 138)
	_brew_progress.size = Vector2(176, 18)
	_brew_progress.value = 0.0
	add_child(_brew_progress)

	_status_label = Label.new()
	_status_label.add_theme_font_size_override("font_size", 11)
	_status_label.add_theme_color_override("font_color", Color(0.8, 0.9, 0.8))
	_status_label.position = Vector2(ro_x + 12, ro_y + 170)
	add_child(_status_label)

	# Recipe panel (right of readout)
	var rp_x := 1060.0
	var recipe_panel := ColorRect.new()
	recipe_panel.position = Vector2(rp_x, ro_y)
	recipe_panel.size = Vector2(210, 380)
	recipe_panel.color = Color(0.06, 0.10, 0.13)
	add_child(recipe_panel)

	var rp_title := Label.new()
	rp_title.text = "— ORDER —"
	rp_title.add_theme_font_size_override("font_size", 11)
	rp_title.add_theme_color_override("font_color", Constants.BRASS_GOLD)
	rp_title.position = Vector2(rp_x + 35, ro_y + 10)
	add_child(rp_title)

	_recipe_label = Label.new()
	_recipe_label.add_theme_font_size_override("font_size", 11)
	_recipe_label.add_theme_color_override("font_color", Color(0.85, 0.85, 0.75))
	_recipe_label.position = Vector2(rp_x + 10, ro_y + 36)
	_recipe_label.size = Vector2(190, 340)
	_recipe_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	add_child(_recipe_label)

	# ── Bottom row: buttons ─────────────────────────────────────────────────
	var btn_y := 470.0
	var btn_configs := [
		{"id": "ignition",   "text": "IGNITION 🔥", "color": Color(0.8, 0.2, 0.1)},
		{"id": "mixer_1",    "text": "MIX 1\nSLOW",  "color": Color(0.5, 0.4, 0.1)},
		{"id": "mixer_2",    "text": "MIX 2\nMED",   "color": Color(0.5, 0.4, 0.1)},
		{"id": "mixer_3",    "text": "MIX 3\nFAST",  "color": Color(0.5, 0.4, 0.1)},
		{"id": "catalyst",   "text": "CATALYST ⚡",   "color": Color(0.35, 0.15, 0.5)},
		{"id": "relief",     "text": "RELIEF ⚙",     "color": Color(0.2, 0.35, 0.45)},
	]

	var btn_script := load("res://scripts/controllers/ButtonController.gd")
	var btn_x := 40.0
	for cfg in btn_configs:
		var btn := Button.new()
		btn.set_script(btn_script)
		btn.set("button_id", cfg["id"])
		btn.text = cfg["text"]
		btn.position = Vector2(btn_x, btn_y)
		btn.size = Vector2(Constants.BUTTON_SIZE + 20, Constants.BUTTON_SIZE + 20)
		btn.add_theme_color_override("font_color", cfg["color"])
		add_child(btn)
		if cfg["id"] == "ignition":
			_ignition_btn = btn
		elif cfg["id"].begins_with("mixer_"):
			_mixer_btns.append(btn)
		elif cfg["id"] == "catalyst":
			_catalyst_btn = btn
		elif cfg["id"] == "relief":
			_relief_btn = btn
		btn_x += Constants.BUTTON_SIZE + 30

	# ── Levers row ──────────────────────────────────────────────────────────
	var lever_y := 590.0
	var lever_script := load("res://scripts/controllers/LeverController.gd")

	var heat_lbl := Label.new()
	heat_lbl.text = "HEAT"
	heat_lbl.add_theme_font_size_override("font_size", 11)
	heat_lbl.add_theme_color_override("font_color", Constants.BRASS_GOLD)
	heat_lbl.position = Vector2(40, lever_y)
	add_child(heat_lbl)

	_heat_slider = HSlider.new()
	_heat_slider.set_script(lever_script)
	_heat_slider.set("lever_id", "heat")
	_heat_slider.position = Vector2(40, lever_y + 22)
	_heat_slider.size = Vector2(240, 20)
	_heat_slider.min_value = 0.0
	_heat_slider.max_value = 1.0
	_heat_slider.step = 0.01
	_heat_slider.value = heat_level
	add_child(_heat_slider)

	var vent_lbl := Label.new()
	vent_lbl.text = "VENT VALVE"
	vent_lbl.add_theme_font_size_override("font_size", 11)
	vent_lbl.add_theme_color_override("font_color", Constants.BRASS_GOLD)
	vent_lbl.position = Vector2(310, lever_y)
	add_child(vent_lbl)

	var vent_slider := HSlider.new()
	vent_slider.set_script(lever_script)
	vent_slider.set("lever_id", "vent")
	vent_slider.position = Vector2(310, lever_y + 22)
	vent_slider.size = Vector2(160, 20)
	vent_slider.min_value = 0.0
	vent_slider.max_value = 1.0
	vent_slider.step = 1.0
	add_child(vent_slider)
	_vent_slider = vent_slider

	# Filter buttons
	var filter_lbl := Label.new()
	filter_lbl.text = "FILTER"
	filter_lbl.add_theme_font_size_override("font_size", 11)
	filter_lbl.add_theme_color_override("font_color", Constants.BRASS_GOLD)
	filter_lbl.position = Vector2(510, lever_y)
	add_child(filter_lbl)

	var prev_btn := Button.new()
	prev_btn.set_script(btn_script)
	prev_btn.set("button_id", "filter_prev")
	prev_btn.text = "◀"
	prev_btn.position = Vector2(510, lever_y + 18)
	prev_btn.size = Vector2(30, 26)
	add_child(prev_btn)
	_filter_prev_btn = prev_btn

	var next_btn := Button.new()
	next_btn.set_script(btn_script)
	next_btn.set("button_id", "filter_next")
	next_btn.text = "▶"
	next_btn.position = Vector2(620, lever_y + 18)
	next_btn.size = Vector2(30, 26)
	add_child(next_btn)
	_filter_next_btn = next_btn
