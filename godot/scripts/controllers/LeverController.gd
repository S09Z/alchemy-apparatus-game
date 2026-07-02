extends HSlider

@export var lever_id: String = ""

func _ready() -> void:
	value_changed.connect(_on_value_changed)

func _on_value_changed(new_value: float) -> void:
	InputManager.lever_changed.emit(lever_id, new_value)
