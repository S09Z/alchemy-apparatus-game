# Development Notes

## Architecture

### Systems
- **ChemistrySystem** - Recipe validation, ingredient mixing
- **MachineController** - State machine, gauge updates
- **RecipeManager** - Recipe selection and progression

### Controllers
- **ButtonController** - 6 button inputs
- **LeverController** - 4 lever inputs
- **GaugeAnimator** - Pressure, temperature, purity

### Managers
- **RecipeManager** - Recipe data
- **SoundManager** - Audio
- **ParticleManager** - Particle effects
- **ProgressManager** - Score tracking

## Color Palette

Always reference Constants.gd for colors:
- BRASS_GOLD = #C89D5C
- COPPER_RUST = #8B4513
- STEEL_GRAY = #4A4E5F
- DEEP_TEAL = #1F3A3F

## Script Template

```gdscript
# scripts/category/FileName.gd
extends Node

## Description

func _ready() -> void:
    """Called on scene start"""
    pass

func _process(delta: float) -> void:
    """Called every frame"""
    pass
```

## Testing

- [ ] Button detection works
- [ ] Lever dragging works
- [ ] Gauges update
- [ ] Particles emit
- [ ] Audio plays
- [ ] Export to HTML5 succeeds

---
Update this as you develop!
