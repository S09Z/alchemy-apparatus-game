extends Control

## Custom-drawn analog gauge with a sweeping needle.
## Needle sweeps from 225° (min) to -45° (max), matching a clock-face layout.

@export var min_value: float = 0.0
@export var max_value: float = 10.0
@export var warning_threshold: float = 6.0
@export var danger_threshold: float = 8.0
@export var unit_label: String = "PSI"

var current_value: float = 0.0
var _display_value: float = 0.0  # smoothed for animation

const START_ANGLE_DEG: float = 225.0
const END_ANGLE_DEG: float = -45.0
const SWEEP_DEG: float = 270.0

func _process(delta: float) -> void:
	_display_value = move_toward(_display_value, current_value, (max_value - min_value) * delta * 3.0)
	queue_redraw()

func set_value(v: float) -> void:
	current_value = clamp(v, min_value, max_value)

func _draw() -> void:
	var center := size / 2.0
	var radius := min(size.x, size.y) * 0.45

	# Gauge face
	draw_circle(center, radius, Color(0.15, 0.18, 0.22))
	draw_arc(center, radius, 0, TAU, 64, Color(0.55, 0.45, 0.25), 2.0)

	# Colored arc zones
	_draw_arc_zone(center, radius * 0.75, 0.0, warning_threshold, Color(0.25, 0.65, 0.35, 0.6), 10.0)
	_draw_arc_zone(center, radius * 0.75, warning_threshold, danger_threshold, Color(0.85, 0.7, 0.1, 0.6), 10.0)
	_draw_arc_zone(center, radius * 0.75, danger_threshold, max_value, Color(0.78, 0.2, 0.15, 0.6), 10.0)

	# Tick marks
	for i in range(11):
		var t := float(i) / 10.0
		var angle := deg_to_rad(START_ANGLE_DEG - t * SWEEP_DEG)
		var inner := center + Vector2(cos(angle), sin(angle)) * radius * 0.78
		var outer := center + Vector2(cos(angle), sin(angle)) * radius * 0.92
		draw_line(inner, outer, Color(0.8, 0.75, 0.55), 1.5)

	# Needle
	var t := (_display_value - min_value) / (max_value - min_value)
	var needle_angle := deg_to_rad(START_ANGLE_DEG - t * SWEEP_DEG)
	var needle_tip := center + Vector2(cos(needle_angle), sin(needle_angle)) * radius * 0.82
	var needle_color := Color(0.9, 0.3, 0.2) if _display_value >= danger_threshold else Color(0.9, 0.85, 0.6)
	draw_line(center, needle_tip, needle_color, 2.5)
	draw_circle(center, 5.0, Color(0.55, 0.45, 0.25))

	# Label
	var font := ThemeDB.fallback_font
	var font_size := 11
	draw_string(font, center + Vector2(-12, radius * 0.55), unit_label, HORIZONTAL_ALIGNMENT_CENTER, -1, font_size, Color(0.75, 0.7, 0.5))
	draw_string(font, center + Vector2(-14, radius * 0.72), "%.1f" % _display_value, HORIZONTAL_ALIGNMENT_CENTER, -1, font_size + 2, Color(0.9, 0.85, 0.6))

func _draw_arc_zone(center: Vector2, radius: float, v_start: float, v_end: float, color: Color, width: float) -> void:
	var t0 := (v_start - min_value) / (max_value - min_value)
	var t1 := (v_end - min_value) / (max_value - min_value)
	var a0 := deg_to_rad(START_ANGLE_DEG - t0 * SWEEP_DEG)
	var a1 := deg_to_rad(START_ANGLE_DEG - t1 * SWEEP_DEG)
	draw_arc(center, radius, a1, a0, 32, color, width)
