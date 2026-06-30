# Phase 2: Core Mechanics Design

**Date:** 2026-06-30  
**Status:** Approved  
**Branch:** feat/phase-2-core-mechanics  

---

## Overview

Phase 2 completes the full game loop. Phase 1 delivered machine physics and a working brew simulation; Phase 2 adds the surrounding structure: ingredient selection, a phase-driven game loop, and a reputation system that unlocks recipes.

**Key decisions:**
- Ingredient selection: shelf panel with click-to-load (no drag, no wrong ingredients)
- Time pressure: none — difficulty comes from managing temp/pressure, not the clock
- Post-brew progression: reputation stars → recipe unlocks

---

## Architecture

### Phase sequence

```
ORDER_DISPLAY → INGREDIENT_SELECT → BREWING → RESULT → (loop)
```

`GameLoopManager` owns this state machine and drives all transitions. MachineController remains focused on machine physics only.

### Responsibility split

| Component | Owns |
|-----------|------|
| `MachineController` | Machine physics, button/lever handling, `IDLE/BREWING/SUCCESS/FAILURE` state |
| `GameLoopManager` | Phase sequence, reputation, recipe unlocks, ingredient validation |
| `ChemistrySystem` | Recipe definitions, ingredient lists, `evaluate_brew()` |
| `IngredientData` | Ingredient type definitions (name, color, property) |

### Signal contract

MachineController emits one new signal:
```gdscript
signal brew_completed(success: bool, purity: float)
```
GameLoopManager listens and handles the outcome. MachineController does not know about reputation or phases.

GameLoopManager calls one new method on MachineController:
```gdscript
func reset() -> void  # clears machine state for next brew
```

### New files

- `scripts/managers/GameLoopManager.gd`
- `scripts/data/IngredientData.gd`

### Modified files

- `scripts/systems/MachineController.gd` — add `brew_completed` signal, add `reset()` method
- `scripts/systems/ChemistrySystem.gd` — add `ingredients` list to each recipe
- `scripts/systems/MachineController.gd` — GameLoopManager node added to MainScene UI build

---

## Ingredient Selection

### When it runs

GameLoopManager enters `INGREDIENT_SELECT` after ORDER_DISPLAY. A shelf panel appears over the chamber center.

### Panel behaviour

- Lists the required ingredients for the active recipe (exactly what's needed — no wrong choices, no inventory)
- Player clicks each ingredient to "load" it; the ingredient row highlights as loaded
- Chamber fill color lerps toward the ingredient's color by `1 / total_ingredients` per load (visual feedback that something is going in)
- Once all required ingredients are loaded, a **"Begin Brewing →"** button appears
- Player presses it → panel hides, GameLoopManager transitions to BREWING, MachineController enables controls

### Data structure

```gdscript
# IngredientData.gd
const INGREDIENTS: Dictionary = {
    "water":          { "name": "Water",          "type": "base",     "color": Color(0.4, 0.6, 0.9) },
    "mint_herb":      { "name": "Mint Herb",       "type": "powder",   "color": Color(0.3, 0.8, 0.4) },
    "golden_essence": { "name": "Golden Essence",  "type": "liquid",   "color": Color(0.9, 0.75, 0.2) },
    "iron_dust":      { "name": "Iron Dust",        "type": "powder",   "color": Color(0.5, 0.5, 0.6) },
    "crimson_sap":    { "name": "Crimson Sap",      "type": "liquid",   "color": Color(0.8, 0.2, 0.2) },
    "azure_crystal":  { "name": "Azure Crystal",    "type": "powder",   "color": Color(0.3, 0.5, 0.9) },
    "moon_dew":       { "name": "Moon Dew",         "type": "liquid",   "color": Color(0.7, 0.8, 1.0) },
}
```

Each recipe in `ChemistrySystem` gains an `ingredients` key:
```gdscript
{
    "name": "Healing Potion",
    "ingredients": ["water", "mint_herb", "golden_essence"],
    ...
}
```

### No drag-and-drop, no order requirement in Phase 2

Animation and drag-and-drop are deferred to Phase 3+. The selection phase is intentionally frictionless — all challenge is in the control panel.

---

## Reputation System

### Star rating per brew

| Purity | Stars | Quality label |
|--------|-------|---------------|
| 80–100% | ⭐⭐⭐ | PERFECT |
| 50–79% | ⭐⭐ | GOOD |
| 20–49% | ⭐ | POOR |
| 0–19% or failure | 0 | FAILED |

### Recipe unlocks (cumulative reputation)

| Reputation threshold | Recipe unlocked |
|---------------------|-----------------|
| 0 stars | Healing Potion (always available) |
| 3 stars | Strength Boost |
| 6 stars | Vision Clarity |

### State in GameLoopManager

```gdscript
var reputation: int = 0
var unlocked_recipes: Array[int] = [0]  # recipe indices
var current_recipe_index: int = 0
```

### Result screen content

- Stars earned this brew (animated display)
- Running reputation total
- Unlock banner if a new recipe just became available
- "Next Order →" button to loop back to ORDER_DISPLAY

### No persistence in Phase 2

Reputation resets on game restart. Save/load is Phase 3+.

---

## Game Loop Phases (detail)

### ORDER_DISPLAY
- Show customer name (generated from a small name list) and order text: *"I need a [recipe name]."*
- Show recipe requirements (temp range, pressure range, brew time, filter if required)
- "Accept Order →" button advances to INGREDIENT_SELECT
- No timer

### INGREDIENT_SELECT
- Shelf panel visible, machine controls disabled
- Player clicks ingredients to load them
- All loaded → "Begin Brewing →" available
- Advancing calls `MachineController.reset()` then enables machine controls

### BREWING
- Shelf panel hidden, machine controls fully active
- MachineController runs its physics tick normally
- When MachineController emits `brew_completed`, GameLoopManager catches it and transitions to RESULT

### RESULT
- Machine controls disabled
- Result overlay shows: quality label, stars, purity %, reputation total, unlock banner if applicable
- "Next Order →" loops back to ORDER_DISPLAY with the next (or newly unlocked) recipe

---

## Out of Scope for Phase 2

- Drag-and-drop ingredients
- Wrong ingredient penalties
- Time pressure / countdown timers
- Save/load persistence
- Sound effects and particle animations (Phase 3)
- Ingredient inventory management
- Customer art / portraits
