# 🧪 ALCHEMICAL APPARATUS - Setup Guide

## ONE-COMMAND SETUP

ตัวสร้างโปรเจค Godot โครงสร้างเสร็จในคำสั่งเดียว! 🚀

---

## 📋 FILES YOU HAVE

```
/outputs/
├── setup.sh              ← ⭐ THE MAGIC SCRIPT (run this!)
├── claude.md             ← Full project brief
├── memory.md             ← Quick reference
└── todo.md               ← Task list
```

---

## 🚀 QUICK START (3 STEPS)

### Step 1: Download Files

```bash
# Files are in /mnt/user-data/outputs/
# Download all 4 files to your computer:
# - setup.sh
# - claude.md
# - memory.md  
# - todo.md
```

### Step 2: Run Setup Script

```bash
# Navigate to where you want project
cd ~/projects  # or anywhere you like

# Run the script
bash setup.sh

# OR with a specific directory name
bash setup.sh AlchemicalApparatus
```

### Step 3: Done! 🎉

```bash
# Your project is ready!
cd AlchemicalApparatus
ls -la

# You'll see:
# ✅ godot/           - Godot project folder
# ✅ docs/            - All documentation
# ✅ builds/          - Export folder
# ✅ README.md        - Project overview
# ✅ .gitignore       - Git config
```

---

## 📁 WHAT THE SCRIPT CREATES

### Complete Folder Structure

```
AlchemicalApparatus/
│
├── 📂 godot/                           ← OPEN THIS IN GODOT
│   ├── scenes/                         - Game scenes
│   ├── scripts/
│   │   ├── systems/                   - Core game systems
│   │   ├── controllers/               - Input controllers
│   │   └── managers/                  - Game managers
│   ├── assets/
│   │   ├── sprites/
│   │   │   ├── buttons/
│   │   │   ├── levers/
│   │   │   ├── gauges/
│   │   │   ├── particles/
│   │   │   └── background/
│   │   ├── sounds/
│   │   │   ├── sfx/
│   │   │   └── music/
│   │   └── fonts/
│   ├── PROJECT_SETUP.md               - Godot setup instructions
│   └── scripts/
│       └── Constants.gd               - Game constants
│
├── 📂 docs/                            ← READ THESE
│   ├── PROJECT_BRIEF.md               - Full game design
│   ├── MEMORY.md                      - Quick reference
│   ├── TODO.md                        - Task list
│   ├── DEVELOPMENT_NOTES.md           - Dev notes
│   ├── gdd/                           - GDD templates
│   ├── design/                        - Design docs
│   └── progress/
│       └── WEEK_01_TEMPLATE.md        - Progress tracking
│
├── 📂 builds/                          ← Export folder
│   └── v1.0-launch/
│
├── 📂 .github/
│   └── ISSUE_TEMPLATE/
│       └── bug_report.md              - GitHub templates
│
├── 📂 tools/                           ← Utility scripts
│   └── scripts/
│
├── README.md                           ← Project overview
├── .gitignore                          ← Git configuration
└── .git/                               ← Version control
```

### Key Template Files Created

✅ **godot/scripts/Constants.gd**
- Color palette (hex codes!)
- Temperature/pressure constants
- Game timing constants

✅ **docs/DEVELOPMENT_NOTES.md**
- Architecture overview
- Script templates
- Testing checklist

✅ **docs/progress/WEEK_01_TEMPLATE.md**
- Weekly progress tracking
- Copy for each week

✅ **.gitignore**
- Configured for Godot development
- Excludes build files, IDE config

---

## 🎮 AFTER SETUP: NEXT STEPS

### Step 1: Copy Documentation Files

```bash
# The script references these files - copy them manually:

cp /path/to/claude.md        AlchemicalApparatus/docs/PROJECT_BRIEF.md
cp /path/to/memory.md        AlchemicalApparatus/docs/MEMORY.md
cp /path/to/todo.md          AlchemicalApparatus/docs/TODO.md
```

### Step 2: Open Godot

```bash
# Download Godot 4.x from https://godotengine.org/

# Open it and:
# 1. Click "Open Project"
# 2. Navigate to: AlchemicalApparatus/godot/
# 3. Click "Open & Edit"
```

### Step 3: Read Documentation

In Godot (or text editor), open:
1. `AlchemicalApparatus/README.md` (overview)
2. `AlchemicalApparatus/godot/PROJECT_SETUP.md` (Godot setup)
3. `AlchemicalApparatus/docs/PROJECT_BRIEF.md` (full design)
4. `AlchemicalApparatus/docs/TODO.md` (tasks)

### Step 4: Start Week 1!

Follow tasks in `docs/TODO.md` PHASE 1:
- [ ] Create MainScene.tscn
- [ ] Create first script
- [ ] Add 6 button placeholders
- [ ] Test in browser export

---

## 🛠️ ADVANCED USAGE

### Use with Git

```bash
cd AlchemicalApparatus

# Script already initialized git
git log                    # See initial commit
git status                 # Check status
git add .
git commit -m "My changes"
git remote add origin https://github.com/yourname/alchemical-apparatus
git push -u origin main
```

### Customize Project Name

```bash
# Create with custom name
bash setup.sh MyCustomProjectName

# Creates:
# MyCustomProjectName/
# ├── godot/
# ├── docs/
# └── ...
```

### Create Multiple Versions

```bash
# Setup for testing
bash setup.sh AlchemicalApparatus-v1

# Setup for backup
bash setup.sh AlchemicalApparatus-backup

# Setup for experiments
bash setup.sh AlchemicalApparatus-experimental
```

---

## ⚠️ REQUIREMENTS

**Before running setup.sh, you need:**

- ✅ Bash (macOS/Linux built-in, Windows: WSL or Git Bash)
- ✅ Basic terminal knowledge
- ✅ ~100MB free disk space
- ✅ Git (optional, but recommended)

**After setup, you need:**

- ✅ Godot 4.x (free download)
- ✅ Text editor (VS Code, Sublime, etc.)
- ✅ Pixel art tool for assets (Aseprite or Krita)

---

## 🐛 TROUBLESHOOTING

### "Permission denied" error

```bash
# Make script executable
chmod +x setup.sh

# Then run
bash setup.sh
```

### "Command not found: bash"

**Windows:**
```bash
# Use Git Bash or WSL
# Download: https://git-scm.com/

# Then run in Git Bash:
bash setup.sh
```

### "Already exists" error

```bash
# The folder already exists
# Either:
# 1. Run in a new directory
cd ~/projects/new-folder
bash setup.sh

# 2. Or specify new name
bash setup.sh AlchemicalApparatus-v2
```

### Godot can't open project

```bash
# Make sure you point to: ProjectFolder/godot/
# NOT: ProjectFolder/

# If Godot gives error, try:
# 1. Delete .godot/ folder
# 2. Restart Godot
# 3. Reopen project
```

---

## 📊 WHAT YOU GET AFTER SETUP

```
✅ Complete folder structure (organized)
✅ Git initialized (version control ready)
✅ Godot project template (ready to open)
✅ Documentation templates (for GDD)
✅ Weekly progress tracker (for motivation)
✅ Constants file (color palette, timings)
✅ .gitignore configured (no build bloat)
✅ README.md created (project overview)
✅ Issue templates (for GitHub)
✅ Dev notes template (architecture guide)

TOTAL TIME TO RUN: ~5-10 seconds ⚡
TOTAL SETUP TIME SAVED: ~30 minutes! 🎉
```

---

## 🎯 VERIFICATION CHECKLIST

After running setup.sh, verify everything:

```bash
cd AlchemicalApparatus

# ✅ Check folders exist
ls -la godot/              # Should show: scenes, scripts, assets
ls -la docs/               # Should show: PROJECT_BRIEF.md, etc.
ls -la builds/             # Should show: v1.0-launch/

# ✅ Check key files
cat README.md              # Should show project overview
cat .gitignore             # Should show Godot patterns

# ✅ Check git
git log                    # Should show initial commit
git status                 # Should be clean

# ✅ All good!
echo "🧪 Setup successful! Ready to develop!"
```

---

## 📖 RECOMMENDED READING ORDER

After setup, read in this order:

1. **README.md** (5 min)
   - Quick overview of project

2. **docs/PROJECT_BRIEF.md** (30 min)
   - Full game design document

3. **docs/MEMORY.md** (10 min)
   - Key concepts and quick reference

4. **docs/TODO.md** (20 min)
   - Understand Week 1 tasks

5. **godot/PROJECT_SETUP.md** (10 min)
   - How to set up Godot specifically

6. **docs/DEVELOPMENT_NOTES.md** (15 min)
   - Architecture and script patterns

**TOTAL READING TIME: ~90 minutes**
**READY TO CODE: 💪 Start Week 1!**

---

## 🚀 FROM HERE TO LAUNCH

```
Setup Complete! ✅
     ↓
Read Documentation (Week 0)
     ↓
PHASE 1: Foundation (Week 1-2)
     ↓
PHASE 2: Core Mechanics (Week 3-4)
     ↓
PHASE 3: Polish (Week 5-6)
     ↓
PHASE 4: Testing (Week 7-8)
     ↓
PHASE 5: Launch Prep (Week 9-10)
     ↓
PHASE 6: Launch! 🎉 (Week 11-12)
     ↓
Game Published on Itch.io! 🌟
```

---

## 💡 TIPS

**Organize your workspace:**
```bash
# Keep docs visible while coding
# Window 1: Godot (left side of screen)
# Window 2: Docs/todo.md (right side of screen)
```

**Update progress weekly:**
```bash
# Copy WEEK_01_TEMPLATE.md
cp docs/progress/WEEK_01_TEMPLATE.md docs/progress/WEEK_01.md

# Fill it in each Friday
# Shows accomplishment & motivation
```

**Commit to git weekly:**
```bash
git add .
git commit -m "Week 1: Foundation complete - buttons working"
git push
```

---

## ❓ QUESTIONS?

Check these files for answers:

| Question | See |
|----------|-----|
| What's the game about? | `docs/PROJECT_BRIEF.md` |
| What controls are there? | `docs/MEMORY.md` → Control Layout |
| What should I do this week? | `docs/TODO.md` → PHASE 1 |
| How do I code X feature? | `docs/DEVELOPMENT_NOTES.md` |
| How do I setup Godot? | `godot/PROJECT_SETUP.md` |

---

## 🎉 YOU'RE READY!

```
✅ Project structure created
✅ Documentation ready
✅ Godot template prepared
✅ Task list organized
✅ Git initialized

NOW:
1. Download Godot 4.x
2. Open AlchemicalApparatus/godot/
3. Create MainScene.tscn
4. Start coding!

GOOD LUCK! 🧪✨
```

---

**Questions about setup?** All info is in the generated files! 📚

**Ready to start coding?** Head to `docs/TODO.md` PHASE 1! 🚀

Happy developing! 🎮
