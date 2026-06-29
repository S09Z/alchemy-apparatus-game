# Godot Project Setup Instructions

## Initial Godot Setup

1. **Open Godot 4.x**
2. **Create New Project** 
3. **Select folder:** Point to this `godot/` directory
4. **Renderer:** Canvas (2D)
5. **Click Create**

## Create Main Scene

In Godot:
1. **Scene → New Scene**
2. **Select:** Node2D (root)
3. **Rename:** MainScene
4. **Save as:** scenes/MainScene.tscn

## Project Structure Created

```
res://
├── scenes/
│   └── MainScene.tscn
├── scripts/
│   ├── systems/
│   ├── controllers/
│   └── managers/
└── assets/
    ├── sprites/
    │   ├── buttons/
    │   ├── levers/
    │   ├── gauges/
    │   └── particles/
    ├── sounds/
    └── fonts/
```

## First Script to Create

Create `scripts/systems/MachineController.gd`:

```gdscript
extends Node2D

func _ready() -> void:
    print("🧪 Machine Controller Ready!")

func _process(delta: float) -> void:
    pass
```

## Export to HTML5

When ready to export:
1. **Project → Export**
2. **Add Template → HTML5**
3. **Export Path:** ../../builds/v1.0-launch/
4. Click **Export Project**

---
Full docs in parent directory: ../docs/PROJECT_BRIEF.md
