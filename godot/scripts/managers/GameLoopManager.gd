extends Control

enum Phase { ORDER_DISPLAY, INGREDIENT_SELECT, BREWING, RESULT }

const CUSTOMER_NAMES := ["Mira", "Aldren", "Torvin", "Sylva", "Edric", "Lune"]

var machine                                    # MachineController node reference
var phase: Phase = Phase.ORDER_DISPLAY
var reputation: int = 0
var unlocked_recipes: Array[int] = [0]
var current_recipe_index: int = 0
var loaded_ingredients: Array[String] = []

# ─── UI refs (populated in _build_overlays) ───────────────────────────────────
var _order_panel: Panel
var _shelf_panel: Control
var _result_panel: Panel
var _ingredient_rows: Array[Button] = []
# Order panel
var _customer_label: Label
var _order_desc_label: Label
var _order_req_label: Label
var _accept_btn: Button
# Shelf panel
var _shelf_title: Label
var _begin_btn: Button
# Result panel
var _result_quality_label: Label
var _result_purity_label: Label
var _result_stars_label: Label
var _result_rep_label: Label
var _result_unlock_label: Label
var _next_btn: Button

# ─── Entry point (called by MachineController after _build_ui) ────────────────
func start(machine_node) -> void:
	machine = machine_node
	machine.brew_completed.connect(_on_brew_completed)
	_build_overlays()
	_enter_order_display()

# ─── Signal handler ───────────────────────────────────────────────────────────
func _on_brew_completed(success: bool, purity: float) -> void:
	machine.set_controls_enabled(false)
	_enter_result(success, purity)

# ─── Phase transitions ────────────────────────────────────────────────────────
func _enter_order_display() -> void:
	machine.set_controls_enabled(false)
	_update_order_panel()
	_order_panel.visible = true
	_shelf_panel.visible = false
	_result_panel.visible = false
	phase = Phase.ORDER_DISPLAY

func _enter_ingredient_select() -> void:
	loaded_ingredients.clear()
	_order_panel.visible = false
	_shelf_panel.visible = true
	_result_panel.visible = false
	_rebuild_shelf()
	phase = Phase.INGREDIENT_SELECT

func _begin_brewing() -> void:
	_shelf_panel.visible = false
	machine.current_recipe = current_recipe_index
	machine.reset()
	machine.set_controls_enabled(true)
	phase = Phase.BREWING

func _enter_result(success: bool, purity: float) -> void:
	var stars := _purity_to_stars(purity, success)
	var prev_rep := reputation
	reputation += stars
	_check_unlocks(prev_rep)
	_update_result_panel(success, purity, stars, prev_rep)
	_result_panel.visible = true
	phase = Phase.RESULT

func _next_order() -> void:
	_advance_recipe()
	_enter_order_display()

# ─── Reputation helpers ───────────────────────────────────────────────────────
func _purity_to_stars(purity: float, success: bool) -> int:
	if not success or purity < 20.0:
		return 0
	if purity >= 80.0:
		return 3
	if purity >= 50.0:
		return 2
	return 1

func _check_unlocks(prev_rep: int) -> void:
	if prev_rep < 3 and reputation >= 3 and not 1 in unlocked_recipes:
		unlocked_recipes.append(1)
	if prev_rep < 6 and reputation >= 6 and not 2 in unlocked_recipes:
		unlocked_recipes.append(2)

func _advance_recipe() -> void:
	var idx := unlocked_recipes.find(current_recipe_index)
	current_recipe_index = unlocked_recipes[(idx + 1) % unlocked_recipes.size()]

# ─── Overlay construction and panel updates (Tasks 5–7) ───────────────────────
func _build_overlays() -> void:
	var W := 1280.0
	var H := 720.0

	# ── Order display panel ────────────────────────────────────────────────────
	_order_panel = Panel.new()
	_order_panel.position = Vector2(W / 2 - 250, H / 2 - 180)
	_order_panel.size = Vector2(500, 360)
	_order_panel.visible = false
	add_child(_order_panel)

	var op_title := Label.new()
	op_title.text = "— NEW ORDER —"
	op_title.add_theme_font_size_override("font_size", 16)
	op_title.add_theme_color_override("font_color", Constants.BRASS_GOLD)
	op_title.position = Vector2(150, 16)
	_order_panel.add_child(op_title)

	_customer_label = Label.new()
	_customer_label.add_theme_font_size_override("font_size", 14)
	_customer_label.add_theme_color_override("font_color", Color(0.9, 0.85, 0.7))
	_customer_label.position = Vector2(16, 52)
	_customer_label.size = Vector2(468, 40)
	_customer_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_order_panel.add_child(_customer_label)

	_order_desc_label = Label.new()
	_order_desc_label.add_theme_font_size_override("font_size", 12)
	_order_desc_label.add_theme_color_override("font_color", Color(0.8, 0.9, 0.8))
	_order_desc_label.position = Vector2(16, 100)
	_order_desc_label.size = Vector2(468, 36)
	_order_panel.add_child(_order_desc_label)

	_order_req_label = Label.new()
	_order_req_label.add_theme_font_size_override("font_size", 11)
	_order_req_label.add_theme_color_override("font_color", Color(0.7, 0.8, 0.9))
	_order_req_label.position = Vector2(16, 148)
	_order_req_label.size = Vector2(468, 160)
	_order_req_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_order_panel.add_child(_order_req_label)

	_accept_btn = Button.new()
	_accept_btn.text = "Accept Order →"
	_accept_btn.position = Vector2(150, 305)
	_accept_btn.size = Vector2(200, 36)
	_accept_btn.pressed.connect(_enter_ingredient_select)
	_order_panel.add_child(_accept_btn)

	# ── Ingredient shelf panel ─────────────────────────────────────────────────
	_shelf_panel = Control.new()
	_shelf_panel.position = Vector2.ZERO
	_shelf_panel.size = Vector2(W, H)
	_shelf_panel.visible = false
	add_child(_shelf_panel)

	var shelf_bg := ColorRect.new()
	shelf_bg.color = Color(0.05, 0.08, 0.10, 0.92)
	shelf_bg.size = Vector2(W, H)
	_shelf_panel.add_child(shelf_bg)

	_shelf_title = Label.new()
	_shelf_title.text = "Select Ingredients"
	_shelf_title.add_theme_font_size_override("font_size", 20)
	_shelf_title.add_theme_color_override("font_color", Constants.BRASS_GOLD)
	_shelf_title.position = Vector2(W / 2 - 120, 80)
	_shelf_panel.add_child(_shelf_title)

	_begin_btn = Button.new()
	_begin_btn.text = "Begin Brewing →"
	_begin_btn.position = Vector2(W / 2 - 100, H - 100)
	_begin_btn.size = Vector2(200, 40)
	_begin_btn.visible = false
	_begin_btn.pressed.connect(_begin_brewing)
	_shelf_panel.add_child(_begin_btn)

	# ── Result panel ───────────────────────────────────────────────────────────
	_result_panel = Panel.new()
	_result_panel.position = Vector2(W / 2 - 240, H / 2 - 200)
	_result_panel.size = Vector2(480, 400)
	_result_panel.visible = false
	add_child(_result_panel)

	var res_title := Label.new()
	res_title.text = "— BREW COMPLETE —"
	res_title.add_theme_font_size_override("font_size", 16)
	res_title.add_theme_color_override("font_color", Constants.BRASS_GOLD)
	res_title.position = Vector2(120, 16)
	_result_panel.add_child(res_title)

	_result_quality_label = Label.new()
	_result_quality_label.add_theme_font_size_override("font_size", 26)
	_result_quality_label.position = Vector2(16, 60)
	_result_quality_label.size = Vector2(448, 44)
	_result_quality_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_result_panel.add_child(_result_quality_label)

	_result_stars_label = Label.new()
	_result_stars_label.add_theme_font_size_override("font_size", 30)
	_result_stars_label.position = Vector2(16, 112)
	_result_stars_label.size = Vector2(448, 50)
	_result_stars_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_result_panel.add_child(_result_stars_label)

	_result_purity_label = Label.new()
	_result_purity_label.add_theme_font_size_override("font_size", 13)
	_result_purity_label.add_theme_color_override("font_color", Color(0.7, 0.9, 0.7))
	_result_purity_label.position = Vector2(16, 174)
	_result_purity_label.size = Vector2(448, 28)
	_result_purity_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_result_panel.add_child(_result_purity_label)

	_result_rep_label = Label.new()
	_result_rep_label.add_theme_font_size_override("font_size", 13)
	_result_rep_label.add_theme_color_override("font_color", Constants.BRASS_GOLD)
	_result_rep_label.position = Vector2(16, 210)
	_result_rep_label.size = Vector2(448, 28)
	_result_rep_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_result_panel.add_child(_result_rep_label)

	_result_unlock_label = Label.new()
	_result_unlock_label.add_theme_font_size_override("font_size", 14)
	_result_unlock_label.add_theme_color_override("font_color", Color(0.4, 1.0, 0.6))
	_result_unlock_label.position = Vector2(16, 250)
	_result_unlock_label.size = Vector2(448, 60)
	_result_unlock_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_result_unlock_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_result_unlock_label.visible = false
	_result_panel.add_child(_result_unlock_label)

	_next_btn = Button.new()
	_next_btn.text = "Next Order →"
	_next_btn.position = Vector2(140, 340)
	_next_btn.size = Vector2(200, 36)
	_next_btn.pressed.connect(_next_order)
	_result_panel.add_child(_next_btn)

func _update_order_panel() -> void:
	var recipe := ChemistrySystem.RECIPES[current_recipe_index]
	var customer := CUSTOMER_NAMES[randi() % CUSTOMER_NAMES.size()]
	_customer_label.text = "%s says: \"I need a %s.\"" % [customer, recipe["name"]]
	_order_desc_label.text = recipe["desc"]

	var req_text := "Requirements:\n"
	req_text += "  Temperature: %.0f – %.0f°C\n" % [recipe["min_temp"], recipe["max_temp"]]
	req_text += "  Pressure: %.1f – %.1f PSI\n" % [recipe["min_pressure"], recipe["max_pressure"]]
	req_text += "  Brew time: %.0f seconds\n" % recipe["brew_time"]
	if recipe["needs_catalyst"]:
		req_text += "  Catalyst required ⚡\n"
	if recipe["filter"] != -1:
		req_text += "  Filter: %s\n" % machine.FILTER_NAMES[recipe["filter"]]
	_order_req_label.text = req_text

func _rebuild_shelf() -> void:
	for btn in _ingredient_rows:
		btn.queue_free()
	_ingredient_rows.clear()
	_begin_btn.visible = false

	var recipe := ChemistrySystem.RECIPES[current_recipe_index]
	var ing_ids: Array = recipe["ingredients"]
	var W := 1280.0
	var row_y := 220.0

	for i in ing_ids.size():
		var ing_id: String = ing_ids[i]
		var ing: Dictionary = IngredientData.INGREDIENTS[ing_id]

		var row := Button.new()
		row.text = "  %s  [%s]" % [ing["name"], ing["type"].to_upper()]
		row.position = Vector2(W / 2 - 200, row_y + i * 70)
		row.size = Vector2(400, 52)
		row.add_theme_color_override("font_color", ing["color"])
		row.add_theme_font_size_override("font_size", 15)
		var captured_id := ing_id
		row.pressed.connect(func(): _on_ingredient_clicked(captured_id, row))
		_shelf_panel.add_child(row)
		_ingredient_rows.append(row)

	_update_chamber_preview()

func _on_ingredient_clicked(ing_id: String, row: Button) -> void:
	if ing_id in loaded_ingredients:
		return
	loaded_ingredients.append(ing_id)
	row.disabled = true
	row.modulate = Color(0.5, 1.0, 0.5)

	var recipe := ChemistrySystem.RECIPES[current_recipe_index]
	var ing_list: Array = recipe["ingredients"]
	_update_chamber_preview()

	if loaded_ingredients.size() == ing_list.size():
		_begin_btn.visible = true

func _update_chamber_preview() -> void:
	if loaded_ingredients.is_empty():
		machine._chamber_fill.color = Color(0.15, 0.15, 0.2)
		return
	var recipe := ChemistrySystem.RECIPES[current_recipe_index]
	var ing_list: Array = recipe["ingredients"]
	var total := float(ing_list.size())
	var blended := Color(0.0, 0.0, 0.0, 0.0)
	for id in loaded_ingredients:
		blended += IngredientData.INGREDIENTS[id]["color"]
	blended /= float(loaded_ingredients.size())
	machine._chamber_fill.color = Color(0.15, 0.15, 0.2).lerp(blended, float(loaded_ingredients.size()) / total)

func _update_result_panel(_success: bool, _purity: float, _stars: int, _prev_rep: int) -> void:
	pass  # implemented in Task 7
