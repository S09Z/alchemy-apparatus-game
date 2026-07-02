extends Node

## Central signal bus for all machine inputs.
## Buttons and levers emit here; MachineController listens here.

signal button_pressed(button_id: String)
signal lever_changed(lever_id: String, value: float)
