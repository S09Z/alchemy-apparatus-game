# CLAUDE.md

Behavioral guidelines to reduce common LLM coding mistakes. Merge with project-specific instructions as needed.

**Tradeoff:** These guidelines bias toward caution over speed. For trivial tasks, use judgment.

## 1. Think Before Coding

**Don't assume. Don't hide confusion. Surface tradeoffs.**

Before implementing:
- State your assumptions explicitly. If uncertain, ask.
- If multiple interpretations exist, present them - don't pick silently.
- If a simpler approach exists, say so. Push back when warranted.
- If something is unclear, stop. Name what's confusing. Ask.

## 2. Simplicity First

**Minimum code that solves the problem. Nothing speculative.**

- No features beyond what was asked.
- No abstractions for single-use code.
- No "flexibility" or "configurability" that wasn't requested.
- No error handling for impossible scenarios.
- If you write 200 lines and it could be 50, rewrite it.

Ask yourself: "Would a senior engineer say this is overcomplicated?" If yes, simplify.

## 3. Surgical Changes

**Touch only what you must. Clean up only your own mess.**

When editing existing code:
- Don't "improve" adjacent code, comments, or formatting.
- Don't refactor things that aren't broken.
- Match existing style, even if you'd do it differently.
- If you notice unrelated dead code, mention it - don't delete it.

When your changes create orphans:
- Remove imports/variables/functions that YOUR changes made unused.
- Don't remove pre-existing dead code unless asked.

The test: Every changed line should trace directly to the user's request.

## 4. Goal-Driven Execution

**Define success criteria. Loop until verified.**

Transform tasks into verifiable goals:
- "Add validation" → "Write tests for invalid inputs, then make them pass"
- "Fix the bug" → "Write a test that reproduces it, then make it pass"
- "Refactor X" → "Ensure tests pass before and after"

For multi-step tasks, state a brief plan:
```
1. [Step] → verify: [check]
2. [Step] → verify: [check]
3. [Step] → verify: [check]
```

Strong success criteria let you loop independently. Weak criteria ("make it work") require constant clarification.

---

**These guidelines are working if:** fewer unnecessary changes in diffs, fewer rewrites due to overcomplication, and clarifying questions come before implementation rather than after mistakes.

---

# 🧪 ALCHEMICAL APPARATUS - Project Brief

**Status:** Pre-Production  
**Team Size:** Solo Developer (initially)  
**Timeline:** 8-12 weeks to MVP  
**Target Platform:** Web Browser (Godot HTML5 export)  
**Target Audience:** Indie game enthusiasts, chill gaming community, puzzle fans  

---

## 📋 PROJECT OVERVIEW

**Alchemical Apparatus** is a 2.5D steampunk alchemy control panel game where players operate an interactive machine to craft potions and medicines. The core loop combines:
- Button pressing / lever pulling (control panel gameplay)
- Chemical mixing mechanics (alchemy crafting)
- Real-time reaction feedback (satisfying visual/audio)
- Recipe discovery and progression

**Visual Style:** Iron Nest (2.5D isometric steampunk) + Potion Craft (alchemy aesthetic)  
**Gameplay Feel:** Opus Magnum (mechanical satisfaction) + Keep Talking Nobody Explodes (time pressure)

---

## 🎮 CORE GAMEPLAY LOOP

```
1. RECIPE PHASE (15 seconds)
   └─ Customer orders potion (heal, boost strength, etc.)
   └─ Recipe book shows required effects

2. INGREDIENT SELECTION (30-60 seconds)
   └─ Player selects ingredients from shelves
   └─ Each ingredient = flavor/color/property
   └─ Load into machine chamber

3. CONTROL PANEL PHASE (60-120 seconds) ⭐ MAIN GAMEPLAY
   └─ Press buttons to activate systems
   └─ Pull levers to control parameters
   └─ Watch gauges for feedback
   └─ Monitor reaction progress
   └─ Time pressure increases difficulty

4. REACTION ANIMATION (30-60 seconds)
   └─ Machine processes mixture
   └─ Visual feedback (steam, glow, color)
   └─ Particle effects on success
   └─ Sound design reinforces action

5. COMPLETION & EVALUATION (15 seconds)
   └─ Bottle the potion
   └─ Show success/failure result
   └─ Reward or feedback
   └─ Reputation/money earned
```

---

## 🎯 KEY FEATURES

### MVP (Minimum Viable Product)
- [ ] 6-8 working buttons/levers on control panel
- [ ] 3-5 basic potion recipes
- [ ] Pressure and temperature gauges (animated)
- [ ] Simple ingredient mixing system
- [ ] Success/failure states
- [ ] Score and progression tracking
- [ ] Basic sound effects
- [ ] Isometric 2.5D graphics

### Post-MVP (Phase 2)
- [ ] 15+ recipes with difficulty scaling
- [ ] Ingredient discovery system
- [ ] Machine upgrades/unlocks
- [ ] Difficulty modes
- [ ] New button/lever mechanics
- [ ] Leaderboard system
- [ ] Custom machine skins
- [ ] Story/lore progression

### Future (Post-Launch)
- [ ] Multiplayer (competitive/cooperative)
- [ ] 3D machine rotation
- [ ] VR support
- [ ] Mobile app version
- [ ] Trading card system
- [ ] Custom recipes from community

---

## 🛠️ TECH STACK

**Engine:** Godot 4.x  
**Export Target:** HTML5 (WebAssembly)  
**Language:** GDScript  
**Graphics:** 2D (Sprites) + 3D models (future)  
**Audio:** Built-in Godot audio  
**Build Tool:** Godot built-in export  
**Hosting:** Itch.io, GitHub Pages  
**3D Modeling:** Blender (for future 3D assets)  
**Pixel Art:** Aseprite or Krita  

### Why Godot?
- Easy 2D → 3D upgrade path
- HTML5 export works great for web
- GDScript = Python-like (easy to learn)
- Visual editor for UI building
- Free and open-source
- Growing web gaming community

---

## 🎨 VISUAL DIRECTION

### Aesthetic
- **Style:** 2.5D Isometric
- **Theme:** Steampunk Alchemy
- **Color Palette:** Brass gold, copper rust, steel gray, deep teal
- **Inspiration:** Iron Nest, Potion Craft, Spiritfarer
- **Mood:** Mysterious, satisfying, magical, industrial

### Key Visual Elements
1. **Main Chamber** - Tall glass vessel with visible liquid and vanes
2. **Pressure Gauge** - Large analog dial showing PSI
3. **Temperature Scale** - Vertical thermometer with mercury-like liquid
4. **Filter Wheel** - Rotating color selector (6 positions)
5. **Buttons** - Red ignition, brass mixer controls, crystal catalyst
6. **Levers** - Vintage throttle for temperature, pump handle for flow
7. **Particles** - Steam, sparks, magical glow effects

### Material Details
- **Brass/Copper:** Warm metallic (#C89D5C), weathered patina, rivets
- **Steel/Iron:** Cool gray (#4A4E5F), rust streaks, oxidation
- **Glass:** Transparent cyan, reflections, inner glow
- **Liquid:** Color-changing based on potion, particles inside
- **Wood:** Warm brown worn handles with grain texture

---

## 🔧 GAME MECHANICS

### Button System (Press & Hold)
```
Button 1: IGNITION 🔥
  └─ Toggles heating system
  └─ Visual: Red metal button with glow
  └─ Feedback: Heating coil glows, steam particles
  └─ State: Active/Inactive (toggle)

Button 2-4: MIXER SPEEDS 🔄
  └─ Controls mixing speed (Slow/Medium/Fast)
  └─ Visual: Brass dials with numbers
  └─ Feedback: Vanes rotate faster, liquid swirls
  └─ State: One active at a time

Button 5: CATALYST RELEASE ⚡
  └─ Adds reactive catalyst
  └─ Visual: Crystal button with electric glow
  └─ Feedback: Lightning particles burst, bright flash
  └─ State: Cooldown timer (can't spam)

Button 6: PRESSURE RELIEF ⚙️
  └─ Emergency valve (auto activates if pressure too high)
  └─ Visual: Iron valve wheel
  └─ Feedback: Steam vents dramatically
  └─ State: Safety mechanism
```

### Lever System (Drag/Pull)
```
Lever 1: TEMPERATURE CONTROL 🌡️
  └─ Range: -10°C to 100°C (continuous)
  └─ Visual: Airplane throttle style
  └─ Feedback: Real-time thermometer updates
  └─ Mechanic: Smooth dragging motion

Lever 2: FLOW RATE PUMP 💧
  └─ Range: 0-100 mL (3 discrete positions)
  └─ Visual: Manual pump handle
  └─ Feedback: Liquid drips from nozzle into flask
  └─ Mechanic: Click or drag to pump

Lever 3: FILTER WHEEL SELECTOR 🎨
  └─ Range: 6 colors (Red, Blue, Green, Yellow, Purple, Clear)
  └─ Visual: Index pointer on wheel
  └─ Feedback: Wheel rotates, light changes color
  └─ Mechanic: Click to cycle or drag to rotate

Lever 4: PRESSURE VENT VALVE 💨
  └─ Range: Closed to Open (0° to 180°)
  └─ Visual: Brass wheel valve
  └─ Feedback: Pressure gauge responds immediately
  └─ Mechanic: Smooth rotation
```

### Chemistry System
```
Ingredient Types:
  • Base: Water, Oil, Alcohol (carrier fluid)
  • Powder: Crushed crystals, herbs (add color/flavor)
  • Liquid: Essences, nectar (add potency)
  • Catalyst: Lightning stones, gems (trigger reaction)

Formula System:
  • Base + Powder + Liquid + Catalyst = Potion
  • Order matters (sequence)
  • Temperature affects outcome
  • Purity determines quality (0-100%)
  • Timing creates variation

Success Conditions:
  ✓ Correct ingredients added
  ✓ Temperature within range
  ✓ Pressure below max
  ✓ Reaction time sufficient
  ✓ Purity above minimum
```

### Gauge & Feedback System
```
Pressure Gauge:
  └─ Range: 0-10 PSI
  └─ Green zone: 0-6 (safe)
  └─ Yellow zone: 6-8 (warning)
  └─ Red zone: 8-10 (danger)
  └─ Mechanic: Needle animates smoothly
  └─ Auto-triggers relief if >8 PSI

Temperature Scale:
  └─ Range: -10°C to 100°C
  └─ Optimal: 40-80°C (by recipe)
  └─ Color tint: Blue (cold) → Red (hot)
  └─ Warning: Text turns red if >90°C
  └─ Damage: Liquid burns if >100°C

Purity Meter:
  └─ Range: 0-100%
  └─ Affects potion quality
  └─ Reduced by: Timing errors, wrong ingredients
  └─ Visual: Bar fills as reaction progresses
  └─ Reward: Higher purity = more money

Status Display:
  └─ Current recipe shown
  └─ Real-time gauges
  └─ Ingredient counter
  └─ Time remaining (if applicable)
```

---

## 📊 PROGRESSION SYSTEM

### Early Game (Recipes 1-3)
```
Tutorial Potions:
  1. Healing Potion (simple, forgiving)
  2. Strength Boost (medium complexity)
  3. Vision Clarity (introduces third ingredient)

Goal: Learn basic controls and succeed
Difficulty: Very easy, clear feedback
```

### Mid Game (Recipes 4-8)
```
Intermediate Potions:
  4. Speed Elixir (timing-based)
  5. Resistance Brew (temperature-sensitive)
  6. Awakening Tonic (catalyst-focused)
  7. Dream Serum (complex combination)
  8. Shadow Essence (introduces risk)

Goal: Master multiple control systems
Difficulty: Medium, some failures expected
```

### Late Game (Recipes 9+)
```
Advanced Potions:
  9. Legendary Draught (high skill required)
  10. Impossible Mixture (extreme conditions)
  11. Hidden Recipes (discovered through experimentation)
  12. Challenge Orders (time pressure)

Goal: Optimize for high scores
Difficulty: Hard, mastery rewarding
```

### Unlocks
```
New Buttons:
  └─ Unlock 2nd mixer button (Week 2)
  └─ Unlock catalyst button (Week 3)
  └─ Unlock pressure relief (Week 4)

New Levers:
  └─ Unlock filter wheel (Week 2)
  └─ Unlock flow rate pump (Week 3)
  └─ Unlock vent valve (Week 4)

Machine Upgrades:
  └─ Faster heating (Week 3)
  └─ Better gauge precision (Week 4)
  └─ Larger chamber (Week 5)
  └─ Visual skins (ongoing)

Ingredients:
  └─ Unlock new powders/essences
  └─ Unlock catalysts
  └─ Find legendary ingredients
```

---

## 🎵 Audio Design

### Sound Effects
```
Button Presses:
  └─ Ignition: Deep mechanical clank + electrical hum
  └─ Mixer: Whirring gear sound with pitch variation
  └─ Catalyst: Electric zap + sparkle sound
  └─ Relief: Loud steam hiss + pressure relief

Lever Pulls:
  └─ Temperature: Smooth mechanical slider sound
  └─ Pump: Click + liquid drip sound
  └─ Filter: Smooth rotation + lock click
  └─ Vent: Creaking wheel + release hiss

Machine Reactions:
  └─ Heating: Gentle bubbling + sizzle
  └─ Mixing: Swirling liquid sound
  └─ Reaction: Sparkle + shimmer sounds
  └─ Success: Satisfying "ding" + chime
  └─ Failure: Buzzer or sad beep

Ambient:
  └─ Background hum (machinery)
  └─ Steam wisps (very subtle)
  └─ Magical ambience (soft shimmer)
```

### Music
```
Main Menu:
  └─ Steampunk orchestral theme
  └─ Mysterious, inviting
  └─ Tempo: 90 BPM
  └─ Duration: Looping, ~2 minutes

Gameplay:
  └─ Relaxing but engaging
  └─ Builds tension subtly with time pressure
  └─ Tempo: 100-120 BPM
  └─ Dynamic: Changes intensity by difficulty

Success Screen:
  └─ Triumphant, celebratory
  └─ Satisfying resolution
  └─ Duration: ~15 seconds

Failure Screen:
  └─ Slightly sad, learning-focused
  └─ Encouraging to retry
  └─ Duration: ~10 seconds
```

---

## 💰 Monetization (Post-Launch)

### Free-to-Play Model
- Base game free with ads (optional)
- Premium removal ($4.99 one-time)
- Cosmetic skins ($0.99-2.99 each)
- Soundtrack purchase ($2.99)

### Itch.io Strategy
- Free core game on itch.io
- "Pay what you want" option (suggested $5)
- Steam release (later, $9.99)
- Console ports (eventually)

### No Pay-to-Win
- All mechanics accessible free
- No advantage for paying
- Only cosmetics/convenience

---

## 📅 DEVELOPMENT TIMELINE

### Week 1-2: Foundation
- [ ] Godot project setup
- [ ] Basic scene structure
- [ ] Button/lever input system
- [ ] Simple 2D graphics placeholder

### Week 3-4: Core Mechanics
- [ ] Chemistry system implementation
- [ ] First 3 recipes working
- [ ] Gauge animations
- [ ] Basic feedback (sounds, particles)

### Week 5-6: Polish & Content
- [ ] Asset creation (sprites, effects)
- [ ] Additional recipes (3-5 more)
- [ ] UI refinement
- [ ] Sound design and music

### Week 7-8: Testing & Optimization
- [ ] Gameplay testing and balance
- [ ] Web export optimization
- [ ] Bug fixing
- [ ] Performance tuning

### Week 9-10: Launch Prep
- [ ] Final asset polish
- [ ] Documentation
- [ ] Itch.io page creation
- [ ] Marketing materials

### Week 11-12: Launch & Post-Launch
- [ ] Release on itch.io
- [ ] Community feedback collection
- [ ] Balance adjustments
- [ ] Planning Phase 2 features

---

## 👥 ROLES & RESPONSIBILITIES

**Solo Developer (You):**
- Godot programming (GDScript)
- Game design & balance
- UI implementation
- Testing & debugging

**Assets Needed:**
- Pixel art sprites (can commission)
- 3D models for future (Blender)
- Sound effects (can use free libraries)
- Music (can commission or use royalty-free)

**Tools & Services:**
- Godot (free)
- Aseprite or Krita (art tools)
- Itch.io (free hosting)
- GitHub (free version control)
- Godot Asset Store (free assets)

---

## 📈 SUCCESS METRICS

### Pre-Launch Targets
- [ ] MVP playable in 8 weeks
- [ ] 5+ recipes balanced and working
- [ ] 500+ downloads first month
- [ ] 4+ star rating on itch.io

### Year 1 Goals
- [ ] 10,000+ downloads
- [ ] $5,000+ revenue (donations + premium)
- [ ] 50+ community feedback items implemented
- [ ] Expand to Steam

### Long-term Vision
- [ ] Console ports (Nintendo Switch, PS5)
- [ ] Mobile app (iOS/Android)
- [ ] Merchandising (posters, clothing)
- [ ] Community-created content
- [ ] Sequel with expanded mechanics

---

## ⚠️ RISKS & MITIGATION

| Risk | Probability | Impact | Mitigation |
|------|-------------|--------|-----------|
| Scope creep | High | Medium | Weekly sprint reviews, MVP focus |
| Asset creation delays | Medium | High | Placeholder assets early, outsource if needed |
| HTML5 performance issues | Medium | Medium | Optimize early, test on multiple browsers |
| Low player retention | Medium | High | Community feedback loop, balance carefully |
| Platform fragmentation | Low | Medium | Test on multiple browsers/devices early |

---

## 🔗 REFERENCES & INSPIRATION

### Games to Study
- **Potion Craft** - Alchemy mechanics, recipe discovery
- **Iron Nest** - 2.5D isometric aesthetic, steampunk design
- **Opus Magnum** - Mechanical satisfaction, feedback systems
- **Keep Talking Nobody Explodes** - Real-time pressure, button mechanics
- **Diner Dash** - Progression and customer satisfaction
- **Spiritfarer** - Art style and warmth

### Visual References
- Steampunk art on Pinterest (search "steampunk control panel")
- Iron Nest on Steam (study visuals)
- Victorian machinery references
- Real vintage pressure gauges
- Alchemy illustrations and manuscripts

### Audio References
- Steampunk ASMR on YouTube
- Godot asset store (free sound effects)
- Freesound.org (royalty-free sounds)
- YouTube Audio Library (music)

---

## 📚 DOCUMENTATION STRUCTURE

```
/docs/
├── GDD.md (Game Design Document - detailed)
├── TECHNICAL.md (Architecture, systems)
├── ASSETS.md (Asset list and requirements)
├── PROGRESS.md (Weekly progress tracking)
└── DECISIONS.md (Design decision log)

/scripts/ (Godot GDScript)
├── systems/
│   ├── ChemistrySystem.gd
│   ├── MachineController.gd
│   └── RecipeManager.gd
├── scenes/
│   ├── MainScene.gd
│   ├── ButtonController.gd
│   └── GaugeAnimator.gd
└── utils/
    ├── Constants.gd
    └── Helpers.gd
```

---

## 🎯 NEXT IMMEDIATE ACTIONS

1. **THIS WEEK:**
   - [ ] Set up Godot project (File → New Project)
   - [ ] Create basic scene structure
   - [ ] Implement first button click and feedback
   - [ ] Test browser export

2. **NEXT WEEK:**
   - [ ] Build 6 working buttons
   - [ ] Implement first 2 gauges
   - [ ] Create first potion recipe
   - [ ] Add basic particle effects

3. **FOLLOWING WEEK:**
   - [ ] Add 2-4 more recipes
   - [ ] Polish button feedback (sounds, animations)
   - [ ] Create all lever controls
   - [ ] Test complete game loop

---

## 💬 NOTES FOR SELF

- **Remember:** Start small, ship fast. MVP first, polish later.
- **Scope:** 6 buttons, 5 recipes, 2 gauges is enough for launch.
- **Polish matters:** Satisfying feedback is THE game, prioritize this.
- **Community:** Release early, get feedback, iterate based on player data.
- **Marketing:** Chill game aesthetic appeals to lo-fi/cozy gaming crowd.
- **Unique Angle:** No other game combines "control panel + alchemy + steampunk"
- **Growth Path:** Web → Steam → Console → Mobile is the plan.

---

**Last Updated:** [Current Date]  
**Version:** 1.0  
**Status:** Ready for Development ✅
