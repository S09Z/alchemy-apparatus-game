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
	pass  # implemented in Task 5

func _update_order_panel() -> void:
	pass  # implemented in Task 5

func _rebuild_shelf() -> void:
	pass  # implemented in Task 6

func _update_chamber_preview() -> void:
	pass  # implemented in Task 6

func _update_result_panel(_success: bool, _purity: float, _stars: int, _prev_rep: int) -> void:
	pass  # implemented in Task 7
