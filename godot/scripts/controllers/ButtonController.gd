extends Button

@export var button_id: String = ""

func _ready() -> void:
	pressed.connect(_on_pressed)

func _on_pressed() -> void:
	InputManager.button_pressed.emit(button_id)
