#!/bin/bash

# 🧪 ALCHEMICAL APPARATUS - Project Setup Script
# One command to setup entire project structure

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
PROJECT_NAME="AlchemicalApparatus"
PROJECT_DIR="${1:-.}"

echo -e "${BLUE}🧪 ALCHEMICAL APPARATUS - Project Setup${NC}"
echo -e "${YELLOW}Setting up project in: $PROJECT_DIR${NC}\n"

# Create main project directory
mkdir -p "$PROJECT_DIR"
cd "$PROJECT_DIR"

# Create folder structure
echo -e "${BLUE}📁 Creating folder structure...${NC}"

# Godot project folders
mkdir -p godot/scenes
mkdir -p godot/scripts/systems
mkdir -p godot/scripts/controllers
mkdir -p godot/scripts/managers
mkdir -p godot/assets/sprites/buttons
mkdir -p godot/assets/sprites/levers
mkdir -p godot/assets/sprites/gauges
mkdir -p godot/assets/sprites/particles
mkdir -p godot/assets/sprites/background
mkdir -p godot/assets/sounds/sfx
mkdir -p godot/assets/sounds/music
mkdir -p godot/assets/fonts

# Documentation folders
mkdir -p docs/gdd
mkdir -p docs/design
mkdir -p docs/progress

# Builds folder
mkdir -p builds/v1.0-launch

# Project management
mkdir -p .github

# Development utilities
mkdir -p tools
mkdir -p tools/scripts

echo -e "${GREEN}✅ Folders created${NC}\n"

# Create initial files
echo -e "${BLUE}📝 Creating initial files...${NC}"

# Create .gitignore
cat > .gitignore << 'GITEOF'
# Godot
.godot/
*.exe
*.zip
*.so
*.dylib
*.dll
*.su
*.po
*.pot
*.gd.rn

# IDE
.vscode/
.idea/
*.swp
*.swo
*~

# OS
.DS_Store
Thumbs.db
.env

# Build outputs
builds/
exports/
*.pck
*.elf

# Temporary
*.tmp
*.bak
*.log

# Local testing
local_builds/
test_builds/
GITEOF

# Create README.md
cat > README.md << 'READMEEOF'
# 🧪 ALCHEMICAL APPARATUS

**Steampunk Alchemy Control Panel Game**

A 2.5D web-based game where players press buttons and pull levers to craft potions in real-time.

## 🎮 Quick Start

1. **Download Godot 4.x** from https://godotengine.org/
2. **Open** the `godot/` folder as a project
3. **Run** the project (F5 or Play button)
4. **Edit** scripts in `godot/scripts/`

## 📁 Project Structure

```
AlchemicalApparatus/
├── godot/                  # Main Godot project
│   ├── scenes/            # .tscn files
│   ├── scripts/           # .gd scripts
│   │   ├── systems/       # Core game systems
│   │   ├── controllers/   # Input/UI controllers
│   │   └── managers/      # Game managers
│   └── assets/            # Sprites, sounds, fonts
├── docs/                  # Documentation
│   ├── PROJECT_BRIEF.md   # Full project brief
│   ├── MEMORY.md          # Quick reference
│   ├── TODO.md            # Task list
│   └── progress/          # Weekly progress logs
├── builds/                # Exported builds
└── tools/                 # Utility scripts
```

## 📚 Documentation

- **[PROJECT_BRIEF.md](docs/PROJECT_BRIEF.md)** - Full game design document
- **[MEMORY.md](docs/MEMORY.md)** - Quick reference guide
- **[TODO.md](docs/TODO.md)** - Task list and timeline

## 🚀 Next Steps

1. Open Godot 4.x
2. Create new project pointing to `godot/` folder
3. Read `docs/PROJECT_BRIEF.md`
4. Check `docs/TODO.md` for Week 1 tasks
5. Start developing!

---

**Created:** June 2026  
**Status:** Ready for Development ✅
READMEEOF

# Create .github/ISSUE_TEMPLATE
mkdir -p .github/ISSUE_TEMPLATE

cat > .github/ISSUE_TEMPLATE/bug_report.md << 'ISSUEEOF'
---
name: Bug Report
about: Report a game bug
title: "[BUG] "
labels: bug
assignees: ''

---

## Describe the Bug
A clear description of what the bug is.

## Steps to Reproduce
1. Go to '...'
2. Click on '...'
3. See error

## Expected Behavior
What should happen instead?

## Screenshots
If applicable, add screenshots.

## Environment
- Browser: [e.g. Chrome, Firefox]
- OS: [e.g. Windows, Mac]
- Screen Size: [e.g. 1920x1080]
ISSUEEOF

# Create project setup notes
cat > godot/PROJECT_SETUP.md << 'PROJEOF'
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
PROJEOF

# Create Constants template
cat > godot/scripts/Constants.gd << 'CONSTEOF'
# scripts/Constants.gd
extends Node

## Game Constants

# Color Palette (ALWAYS USE THESE)
const BRASS_GOLD = Color("#C89D5C")
const COPPER_RUST = Color("#8B4513")
const STEEL_GRAY = Color("#4A4E5F")
const DEEP_TEAL = Color("#1F3A3F")
const DANGER_RED = Color("#C74C3B")
const ALCHEMIC_GREEN = Color("#3FA796")
const LIGHTNING_BLUE = Color("#6BA4FF")
const STEAM_WHITE = Color("#E8E8E8")
const MAGICAL_PURPLE = Color("#7B5BA6")

# Temperature
const MIN_TEMP = -10.0
const MAX_TEMP = 100.0
const OPTIMAL_TEMP_BUFFER = 10.0

# Pressure
const MAX_PRESSURE = 10.0
const WARNING_PRESSURE = 6.0
const DANGER_PRESSURE = 8.0

# Timing (seconds)
const REACTION_MIN_TIME = 60.0
const REACTION_MAX_TIME = 120.0
const ORDER_DISPLAY_TIME = 15.0
const RESULT_DISPLAY_TIME = 3.0

# Purity
const MIN_PURITY = 0.0
const MAX_PURITY = 100.0

# UI
const BUTTON_SIZE = 80
const LEVER_SENSITIVITY = 2.0
const GAUGE_ANIMATION_MS = 800
CONSTEOF

# Create development notes
cat > docs/DEVELOPMENT_NOTES.md << 'DEVEOF'
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
DEVEOF

# Create progress template
cat > docs/progress/WEEK_01_TEMPLATE.md << 'WEEKEOF'
# Week 1 Progress Report

**Dates:** [Start] - [End]  
**Status:** In Progress

## ✅ Completed Tasks
- [ ] Task 1
- [ ] Task 2

## 🔄 In Progress
- [ ] Task 3

## ⚠️ Blockers
- None yet

## 📝 Notes
- Add notes here
- Issues encountered
- Solutions applied

## 📸 Progress Media
- Add screenshots/GIFs showing progress

## ⏭️ Next Week
- Plan next tasks here

---
*Copy this template for each week*
WEEKEOF

echo -e "${GREEN}✅ All files created${NC}\n"

# Initialize Git if available
if command -v git &> /dev/null; then
    echo -e "${BLUE}🔗 Initializing Git...${NC}"
    git init
    git add .
    git commit -m "🚀 Initial project setup - Alchemical Apparatus" 2>/dev/null || echo "Git commit skipped"
    echo -e "${GREEN}✅ Git initialized${NC}\n"
fi

# Summary
echo -e "${BLUE}════════════════════════════════════════════${NC}"
echo -e "${GREEN}✅ PROJECT SETUP COMPLETE!${NC}"
echo -e "${BLUE}════════════════════════════════════════════${NC}\n"

echo -e "${YELLOW}📁 Created Structure:${NC}"
echo "  godot/              ← Godot project"
echo "  godot/scenes/       ← Game scenes"
echo "  godot/scripts/      ← GDScript files"
echo "  godot/assets/       ← Sprites, sounds, fonts"
echo "  docs/               ← Documentation"
echo "  builds/             ← Export builds"
echo ""

echo -e "${YELLOW}📚 Key Files to Read:${NC}"
echo "  1. README.md                 ← Start here!"
echo "  2. docs/PROJECT_BRIEF.md     ← Full design"
echo "  3. docs/MEMORY.md            ← Quick ref"
echo "  4. docs/TODO.md              ← Task list"
echo ""

echo -e "${YELLOW}🎮 Next: Open Godot and:${NC}"
echo "  1. Create new project in godot/"
echo "  2. Create MainScene.tscn"
echo "  3. Start Week 1 tasks!"
echo ""

echo -e "${BLUE}════════════════════════════════════════════${NC}"
echo -e "${GREEN}🧪 Ready to develop! Let's go! 🚀${NC}"
echo -e "${BLUE}════════════════════════════════════════════${NC}\n"
