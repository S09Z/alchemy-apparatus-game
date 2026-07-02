extends Node2D

func _ready() -> void:
	_build_ui()
	await get_tree().create_timer(1.8).timeout
	get_tree().change_scene_to_file("res://scenes/MainScene.tscn")

func _build_ui() -> void:
	var bg := ColorRect.new()
	bg.color = Constants.DEEP_TEAL
	bg.size = Vector2(1280, 720)
	add_child(bg)

	var title := Label.new()
	title.text = "✦ ALCHEMICAL APPARATUS ✦"
	title.add_theme_font_size_override("font_size", 36)
	title.add_theme_color_override("font_color", Constants.BRASS_GOLD)
	title.position = Vector2(1280 / 2 - 260, 720 / 2 - 40)
	add_child(title)

	var sub := Label.new()
	sub.text = "Loading laboratory..."
	sub.add_theme_font_size_override("font_size", 14)
	sub.add_theme_color_override("font_color", Color(0.6, 0.7, 0.65))
	sub.position = Vector2(1280 / 2 - 80, 720 / 2 + 20)
	add_child(sub)
