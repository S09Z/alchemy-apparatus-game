# Phase 2: Core Mechanics — Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add a phase-driven game loop (ORDER_DISPLAY → INGREDIENT_SELECT → BREWING → RESULT) with ingredient selection, reputation stars, and recipe unlocks around the existing Phase 1 brew simulation.

**Architecture:** `GameLoopManager` (new Control node, child of MachineController) owns all phase transitions and overlay UIs. `MachineController` gains a `brew_completed` signal and `reset()` / `set_controls_enabled()` methods; it loses its result overlay (GameLoopManager owns that now). `IngredientData` and `ChemistrySystem` supply pure data.

**Tech Stack:** Godot 4.3, GDScript. No unit test runner — verification is in-game checks described per task.

---

## File Structure

| File | Status | Responsibility |
|------|--------|---------------|
| `godot/scripts/data/IngredientData.gd` | **Create** | 7 ingredient definitions (name, type, color) |
| `godot/scripts/managers/GameLoopManager.gd` | **Create** | Phase state machine, overlay panels, reputation |
| `godot/scripts/systems/ChemistrySystem.gd` | **Modify** | Add `"ingredients"` key to each recipe |
| `godot/scripts/systems/MachineController.gd` | **Modify** | Add signal + methods, remove result overlay |
| `godot/project.godot` | **Modify** | Register IngredientData autoload |

---

## Task 1: Create IngredientData autoload

**Files:**
- Create: `godot/scripts/data/IngredientData.gd`
- Modify: `godot/project.godot`

- [ ] Create `godot/scripts/data/IngredientData.gd`:

```gdscript
extends Node

const INGREDIENTS: Dictionary = {
    "water":          { "name": "Water",          "type": "base",    "color": Color(0.4, 0.6, 0.9) },
    "mint_herb":      { "name": "Mint Herb",       "type": "powder",  "color": Color(0.3, 0.8, 0.4) },
    "golden_essence": { "name": "Golden Essence",  "type": "liquid",  "color": Color(0.9, 0.75, 0.2) },
    "iron_dust":      { "name": "Iron Dust",       "type": "powder",  "color": Color(0.5, 0.5, 0.6) },
    "crimson_sap":    { "name": "Crimson Sap",     "type": "liquid",  "color": Color(0.8, 0.2, 0.2) },
    "azure_crystal":  { "name": "Azure Crystal",   "type": "powder",  "color": Color(0.3, 0.5, 0.9) },
    "moon_dew":       { "name": "Moon Dew",        "type": "liquid",  "color": Color(0.7, 0.8, 1.0) },
}
```

- [ ] Open `godot/project.godot`. Under `[autoload]`, add this line after the existing entries:

```
IngredientData="*res://scripts/data/IngredientData.gd"
```

- [ ] Commit:

```bash
git add godot/scripts/data/IngredientData.gd godot/project.godot
git commit -m "feat: add IngredientData autoload with 7 ingredient definitions"
```

---

## Task 2: Add ingredients to ChemistrySystem recipes

**Files:**
- Modify: `godot/scripts/systems/ChemistrySystem.gd`

- [ ] Replace the entire `RECIPES` constant with this version (adds `"ingredients"` key to each recipe):

```gdscript
const RECIPES: Array[Dictionary] = [
    {
        "name": "Healing Potion",
        "desc": "Soothe wounds and restore vitality.",
        "ingredients": ["water", "mint_herb", "golden_essence"],
        "min_temp": 40.0,
        "max_temp": 70.0,
        "min_pressure": 1.0,
        "max_pressure": 5.0,
        "brew_time": 30.0,
        "needs_catalyst": false,
        "filter": -1,
    },
    {
        "name": "Strength Boost",
        "desc": "Amplify muscle and will.",
        "ingredients": ["water", "iron_dust", "crimson_sap"],
        "min_temp": 55.0,
        "max_temp": 85.0,
        "min_pressure": 2.0,
        "max_pressure": 6.0,
        "brew_time": 45.0,
        "needs_catalyst": true,
        "filter": 0,  # RUBY
    },
    {
        "name": "Vision Clarity",
        "desc": "See past fog and shadow.",
        "ingredients": ["moon_dew", "azure_crystal", "water"],
        "min_temp": 30.0,
        "max_temp": 55.0,
        "min_pressure": 0.5,
        "max_pressure": 3.5,
        "brew_time": 40.0,
        "needs_catalyst": false,
        "filter": 1,  # AZURE
    },
]
```

- [ ] Commit:

```bash
git add godot/scripts/systems/ChemistrySystem.gd
git commit -m "feat: add ingredients list to each recipe in ChemistrySystem"
```

---

## Task 3: Extend MachineController for Phase 2 integration

**Files:**
- Modify: `godot/scripts/systems/MachineController.gd`

MachineController needs to: (a) emit `brew_completed` instead of showing its own result overlay, (b) expose `reset()` and `set_controls_enabled()` for GameLoopManager to call, (c) store refs to all interactive controls so `set_controls_enabled` can reach them.

### 3a — Add new stored refs

- [ ] In the `# ─── UI refs` section, add three new vars after `_relief_btn`:

```gdscript
var _vent_slider: HSlider
var _filter_prev_btn: Button
var _filter_next_btn: Button
```

- [ ] Remove the `var _result_overlay: Panel` line (result overlay is going away).

### 3b — Add brew_completed signal

- [ ] After the `var game_state` line (around line 16), add:

```gdscript
signal brew_completed(success: bool, purity: float)
```

### 3c — Modify _check_game_state to emit signal

- [ ] Replace the `_check_game_state()` function body with:

```gdscript
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
```

### 3d — Add reset() method

- [ ] Add this method after `_trigger_relief()`:

```gdscript
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
    _filter_label.text = FILTER_NAMES[filter_index]
    _filter_display.color = FILTER_COLORS[filter_index]
    _update_recipe_display()
```

### 3e — Add set_controls_enabled() method

- [ ] Add this method after `reset()`:

```gdscript
func set_controls_enabled(enabled: bool) -> void:
    _ignition_btn.disabled = not enabled
    for btn in _mixer_btns:
        btn.disabled = not enabled
    _catalyst_btn.disabled = not enabled
    _relief_btn.disabled = not enabled
    _heat_slider.editable = enabled
    _vent_slider.editable = enabled
    _filter_prev_btn.disabled = not enabled
    _filter_next_btn.disabled = not enabled
```

### 3f — Store vent_slider and filter button refs in _build_ui()

- [ ] In `_build_ui()`, find `var vent_slider := HSlider.new()`. On the next line after setting it up (after `vent_slider.step = 1.0`), add:

```gdscript
_vent_slider = vent_slider
```

- [ ] Find `var prev_btn := Button.new()`. After its setup block, add:

```gdscript
_filter_prev_btn = prev_btn
```

- [ ] Find `var next_btn := Button.new()`. After its setup block, add:

```gdscript
_filter_next_btn = next_btn
```

### 3g — Remove result overlay from _build_ui()

- [ ] Delete the entire result overlay block from `_build_ui()`. It starts at `# ── Result overlay ──` and ends with the `_result_overlay.visibility_changed.connect(...)` closure (approximately 30 lines). Delete all of it.

### 3h — Remove orphaned methods and button handler

- [ ] Delete the `_show_result()` function entirely.

- [ ] Delete the `_restart_game()` function entirely.

- [ ] In `_on_button_pressed()`, delete the `"restart": _restart_game()` line.

- [ ] Verify: `_update_ui()` does not reference `_result_overlay`. It shouldn't — only the status label reads `game_state`.

- [ ] Run game in Godot. Verify: game loads without errors, all controls are visible. Igniting and adjusting controls works. When purity hits 0 or brew completes, nothing happens visually (no result overlay — GameLoopManager will handle that in Task 8). Godot output log should be clean.

- [ ] Commit:

```bash
git add godot/scripts/systems/MachineController.gd
git commit -m "feat: add brew_completed signal, reset(), set_controls_enabled() to MachineController; remove result overlay"
```

---

## Task 4: Create GameLoopManager — skeleton, phase logic, reputation

**Files:**
- Create: `godot/scripts/managers/GameLoopManager.gd`

All class-level vars are declared here. Phase logic and reputation/unlock logic are implemented here. Overlay construction and panel-specific methods come in Tasks 5–7.

- [ ] Create `godot/scripts/managers/GameLoopManager.gd`:

```gdscript
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
```

- [ ] Commit:

```bash
git add godot/scripts/managers/GameLoopManager.gd
git commit -m "feat: GameLoopManager skeleton — phase state machine, reputation, unlock logic"
```

---

## Task 5: Build overlay panels + order display panel

**Files:**
- Modify: `godot/scripts/managers/GameLoopManager.gd`

Replace the three stub methods (`_build_overlays`, `_update_order_panel`) with real implementations. `_build_overlays` builds all three panel structures at once.

- [ ] Replace `_build_overlays()` with:

```gdscript
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
```

- [ ] Replace `_update_order_panel()` with:

```gdscript
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
```

- [ ] Run game. Expected: order display panel appears on launch with a customer name, recipe description, and requirements. "Accept Order →" button is visible. Pressing it should show a blank shelf panel (no ingredient rows yet — `_rebuild_shelf` is still a stub). No errors in Godot output.

- [ ] Commit:

```bash
git add godot/scripts/managers/GameLoopManager.gd
git commit -m "feat: build all overlay panels and implement order display panel"
```

---

## Task 6: Implement ingredient shelf runtime behavior

**Files:**
- Modify: `godot/scripts/managers/GameLoopManager.gd`

Replace the three stub methods with implementations. Ingredient rows are built dynamically at `_enter_ingredient_select` time (not at `_build_overlays` time), so they can reflect the current recipe.

- [ ] Replace `_rebuild_shelf()` with:

```gdscript
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
```

- [ ] Replace `_on_ingredient_clicked()` stub (which doesn't exist yet — add this new method):

```gdscript
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
```

- [ ] Replace `_update_chamber_preview()` with:

```gdscript
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
```

- [ ] Run game. Expected:
  1. Accept order → shelf shows 3 ingredient buttons, each colored and labeled
  2. Click each → button grays out and turns green, chamber fill shifts color
  3. After all 3 clicked → "Begin Brewing →" button appears at bottom
  4. "Begin Brewing →" → shelf hides, all machine controls become active (ignition, mixers, etc.)
  5. Brew simulation runs as normal. No errors in output.

- [ ] Commit:

```bash
git add godot/scripts/managers/GameLoopManager.gd
git commit -m "feat: ingredient shelf — click to load, chamber color preview, begin brewing trigger"
```

---

## Task 7: Implement result screen with stars and reputation

**Files:**
- Modify: `godot/scripts/managers/GameLoopManager.gd`

- [ ] Replace `_update_result_panel()` with:

```gdscript
func _update_result_panel(success: bool, purity: float, stars: int, prev_rep: int) -> void:
    if success:
        var quality: String
        if purity >= 80.0:
            quality = "PERFECT"
        elif purity >= 50.0:
            quality = "GOOD"
        else:
            quality = "POOR"
        _result_quality_label.text = quality
        _result_quality_label.add_theme_color_override("font_color", Color(0.4, 1.0, 0.5))
    else:
        _result_quality_label.text = "FAILED"
        _result_quality_label.add_theme_color_override("font_color", Color(1.0, 0.3, 0.2))

    var star_str := ""
    for i in 3:
        star_str += "★" if i < stars else "☆"
    _result_stars_label.text = star_str

    _result_purity_label.text = "Purity: %.0f%%" % purity
    _result_rep_label.text = "Reputation: %d ★ total" % reputation

    var new_unlock := false
    if prev_rep < 3 and reputation >= 3 and 1 in unlocked_recipes:
        _result_unlock_label.text = "✦ Strength Boost recipe unlocked!"
        new_unlock = true
    elif prev_rep < 6 and reputation >= 6 and 2 in unlocked_recipes:
        _result_unlock_label.text = "✦ Vision Clarity recipe unlocked!"
        new_unlock = true
    _result_unlock_label.visible = new_unlock
```

- [ ] Run game. Complete a brew (ignite, set heat lever, let brew_time tick down). Expected:
  - Result panel appears with quality label (PERFECT/GOOD/POOR/FAILED), star display (★★★, ★★☆, etc.), purity %, and reputation total
  - Unlock banner is hidden on first brew (reputation < 3)
  - "Next Order →" returns to order display for another round

- [ ] Brew 3 more times with any outcome that earns stars. Verify: when cumulative reputation crosses 3, the result screen shows "✦ Strength Boost recipe unlocked!". Verify: accepting the next order now cycles to Strength Boost on `_advance_recipe()` (order display will show it if current recipe cycles to index 1).

- [ ] Commit:

```bash
git add godot/scripts/managers/GameLoopManager.gd
git commit -m "feat: result screen with star rating, reputation total, and recipe unlock banner"
```

---

## Task 8: Wire GameLoopManager into MachineController

**Files:**
- Modify: `godot/scripts/systems/MachineController.gd`

GameLoopManager must be added as the **last** child of MachineController so its overlay panels render on top of all machine UI.

- [ ] At the very end of `_build_ui()` (after all other `add_child` calls), add:

```gdscript
    # ── Game loop manager — must be last child so panels render on top ──────────
    var glm_script = load("res://scripts/managers/GameLoopManager.gd")
    var glm := Control.new()
    glm.set_script(glm_script)
    glm.position = Vector2.ZERO
    glm.size = Vector2(W, H)
    add_child(glm)
    glm.start(self)
```

- [ ] Run game. Walk through the complete loop:
  1. Boot screen → main scene → order display panel appears with customer + recipe
  2. "Accept Order →" → ingredient shelf visible, machine controls disabled
  3. Click all 3 ingredients (observe each turns green, chamber shifts color)
  4. "Begin Brewing →" → shelf hides, controls enabled
  5. Ignite, set heat ~50%, watch temperature climb to 40–70°C range, mixer on slow (1–5 PSI)
  6. Brew progress bar fills over 30 seconds → result panel appears
  7. Stars and purity display correctly
  8. "Next Order →" loops back to step 1

- [ ] Verify controls are disabled when order display is showing (buttons should not respond to clicks).

- [ ] Verify that after earning 3 total stars, the next result screen shows the unlock banner and the order after that shows Strength Boost.

- [ ] Commit:

```bash
git add godot/scripts/systems/MachineController.gd
git commit -m "feat: wire GameLoopManager into MachineController — full Phase 2 loop active"
```

---

## Self-Review

### Spec coverage

| Spec requirement | Task |
|-----------------|------|
| ORDER_DISPLAY phase with customer + requirements | Task 5 |
| INGREDIENT_SELECT with shelf panel | Task 5 (structure) + Task 6 (behavior) |
| Click-to-load ingredients | Task 6 |
| Chamber color lerps as ingredients load | Task 6 |
| "Begin Brewing →" after all loaded | Task 6 |
| BREWING phase — machine controls active | Task 3 + Task 8 |
| brew_completed signal | Task 3 |
| MachineController.reset() | Task 3 |
| RESULT phase with quality + stars | Task 7 |
| 0/1/2/3 stars by purity threshold | Task 4 |
| Cumulative reputation counter | Task 4 + Task 7 |
| Unlock at 3 stars (Strength Boost) | Task 4 + Task 7 |
| Unlock at 6 stars (Vision Clarity) | Task 4 + Task 7 |
| Unlock banner on result screen | Task 7 |
| "Next Order →" loops back | Task 4 |
| Controls disabled during non-BREWING phases | Task 3 + Task 4 |
| IngredientData definitions | Task 1 |
| Ingredients in ChemistrySystem recipes | Task 2 |
| GameLoopManager owns phase state | Task 4 |
| No time pressure | (intentionally absent) |
| No drag-and-drop | (intentionally absent) |
| No persistence | (intentionally absent) |

### Type consistency check

- `machine.brew_completed` signal: defined Task 3, connected Task 4 ✓
- `machine.reset()`: defined Task 3, called Task 4 (`_begin_brewing`) ✓
- `machine.set_controls_enabled(bool)`: defined Task 3, called Task 4 ✓
- `machine.current_recipe`: existing var in MachineController ✓
- `machine._chamber_fill`: existing var in MachineController ✓
- `machine.FILTER_NAMES`: existing const in MachineController ✓
- `IngredientData.INGREDIENTS`: defined Task 1, used Task 6 ✓
- `ChemistrySystem.RECIPES[i]["ingredients"]`: added Task 2, used Task 6 ✓
- `_ingredient_rows: Array[Button]`: declared Task 4, populated Task 6 ✓
- `_begin_btn`: declared Task 4, created in `_build_overlays` Task 5, shown/hidden Task 6 ✓
- `_result_unlock_label`: declared Task 4, created Task 5, updated Task 7 ✓
