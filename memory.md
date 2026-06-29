# 🧠 PROJECT MEMORY: ALCHEMICAL APPARATUS

**Project:** Alchemical Apparatus - Steampunk Alchemy Control Panel Game  
**Developer:** Solo indie dev (Thailand-based)  
**Status:** Pre-Production  
**Created:** June 2026  

---

## 🎯 CORE CONCEPT (One Sentence)
**Steampunk alchemy machine where players press buttons and pull levers to craft potions in real-time, combining Iron Nest's 2.5D aesthetic with Potion Craft's alchemy mechanics.**

---

## 🔑 KEY DESIGN PILLARS

1. **Satisfying Mechanical Feedback**
   - Every button press has visual + audio response
   - Gauges animate smoothly with real values
   - Particles and effects reinforce actions
   - "Feel over graphics" philosophy

2. **Real-Time Control Panel Gameplay**
   - Players actively control machine during reaction
   - Multiple simultaneous systems (temp, pressure, mixing)
   - Time pressure creates engagement
   - No automation = player always involved

3. **Steampunk Aesthetic (Iron Nest Inspired)**
   - 2.5D isometric perspective
   - Brass gold, copper rust, steel gray colors
   - Detailed mechanical components with rivets
   - Victorian-era machinery meets fantasy magic

4. **Satisfying Alchemy (Potion Craft Inspired)**
   - Recipe discovery through experimentation
   - Chemistry system with real rules
   - Multiple ingredients create different outcomes
   - Learning curve feels rewarding

5. **Chill but Engaging**
   - No punishment for failure (just "try again")
   - Contemplative pacing (not hectic like Overcooked)
   - Progression system gives sense of mastery
   - Appeal to lo-fi/cozy gaming community

---

## 🕹️ GAME LOOP (30-90 seconds per round)

```
1. Order appears (15s) → "Customer needs healing potion"
2. Select ingredients (30-60s) → Pick from shelves
3. Load & control machine (60-120s) ⭐ CORE GAMEPLAY
   - Press ignition button (start heating)
   - Drag temperature lever to optimal range
   - Select mixing speed (3 buttons)
   - Press catalyst button when right moment
   - Monitor gauges in real-time
   - Watch reaction progress
4. Bottle result (10s) → Success/failure animation
5. Repeat with new recipe
```

---

## 🎮 CONTROL PANEL LAYOUT

### BUTTONS (6 Total)
| Button | Position | Function | Visual |
|--------|----------|----------|--------|
| **Ignition** 🔥 | Top-left | Start heating | Red metal, glows when active |
| **Mixer 1** (Slow) | Left side | Slow mixing speed | Brass dial with "1" |
| **Mixer 2** (Med) | Left side | Medium speed | Brass dial with "2" |
| **Mixer 3** (Fast) | Left side | Fast speed | Brass dial with "3" |
| **Catalyst** ⚡ | Bottom-center | Add reaction | Crystal with blue glow |
| **Relief** ⚙️ | Top-right | Emergency pressure | Iron valve wheel |

### LEVERS (4 Total)
| Lever | Range | Function | Visual |
|-------|-------|----------|--------|
| **Temperature** 🌡️ | -10 to 100°C | Control heat | Airplane throttle style |
| **Pump** 💧 | 0-100mL | Control liquid flow | Manual pump handle |
| **Filter** 🎨 | 6 colors | Change color/flavor | Rotating color wheel |
| **Vent** 💨 | Closed-Open | Control pressure | Brass valve wheel |

### GAUGES (3 Main)
| Gauge | Range | Status | Visual |
|-------|-------|--------|--------|
| **Pressure** | 0-10 PSI | Green/Yellow/Red | Large analog dial |
| **Temperature** | -10-100°C | Safe/Warning/Hot | Vertical thermometer |
| **Purity** | 0-100% | Quality indicator | Bar graph on UI |

---

## 🧪 CHEMISTRY SYSTEM

### Ingredient Categories
- **Base:** Water, Oil, Alcohol (required)
- **Powder:** Herbs, crystals (flavor/color)
- **Liquid:** Essences, nectar (potency)
- **Catalyst:** Magical elements (triggers reaction)

### Recipe Structure (Example)
```
HEALING POTION
├─ Base: Water
├─ Powder: Mint herb
├─ Liquid: Golden essence
├─ Catalyst: Life crystal
├─ Optimal Temp: 60°C
├─ Duration: 90 seconds
└─ Yield: High purity possible
```

### Success Formula
```
✓ Correct ingredients + ✓ Right temperature + 
✓ Right timing + ✓ Adequate purity = SUCCESS
```

---

## 🎨 COLOR PALETTE (MUST MAINTAIN)

**Primary Colors:**
- Brass Gold: `#C89D5C` (main frame, buttons)
- Copper Rust: `#8B4513` (pipes, accents)
- Steel Gray: `#4A4E5F` (mechanical, shadows)
- Deep Teal: `#1F3A3F` (background)

**Accent Colors:**
- Danger Red: `#C74C3B` (warnings, hot)
- Alchemic Green: `#3FA796` (reactions)
- Lightning Blue: `#6BA4FF` (catalyst, energy)
- Steam White: `#E8E8E8` (glow, highlights)
- Magical Purple: `#7B5BA6` (potion glow)

---

## 🛠️ TECH STACK

- **Engine:** Godot 4.x (confirmed choice for web + 3D upgrade path)
- **Export:** HTML5 / WebAssembly
- **Language:** GDScript (Python-like, comfortable for solo dev)
- **Graphics:** 2D sprites (isometric), future 3D models from Blender
- **Audio:** Godot built-in
- **Hosting:** Itch.io (free, indie-friendly)
- **Version Control:** GitHub (free)

### Why Godot?
- Best for 2D web games with 3D upgrade potential
- HTML5 export = no install needed
- Free, open-source, community-driven
- GDScript is approachable (like Python)
- Can use visual editor for UI

---

## 📊 MVP SCOPE (LAUNCH TARGET)

**MINIMUM FOR LAUNCH:**
- ✅ 6 working buttons/levers
- ✅ 3-5 recipes (tutored → challenging)
- ✅ 3 main gauges (pressure, temp, purity)
- ✅ Basic particle effects (steam, sparks)
- ✅ Sound effects + music
- ✅ Success/failure states
- ✅ Score tracking
- ✅ UI panels (recipe, status, ingredients)

**NOT NEEDED FOR LAUNCH:**
- ❌ 3D graphics (can add later)
- ❌ 20+ recipes (start small)
- ❌ Multiplayer (post-launch feature)
- ❌ Mobile optimization (web first)
- ❌ Advanced monetization (Itch.io free/donate)

---

## 🎯 SIMILAR GAMES TO LEARN FROM

**Primary Reference: IRON NEST**
- Aesthetic + visual style
- 2.5D isometric perspective
- Steampunk color grading
- Component detail level

**Secondary Reference: POTION CRAFT**
- Alchemy mixing mechanics
- Recipe discovery system
- Visual feedback on reactions
- Learning curve design

**Tertiary Reference: OPUS MAGNUM**
- Mechanical satisfaction feel
- Button/lever feedback
- Cause-and-effect clarity
- Complexity progression

---

## 📈 PROGRESSION PATH

### Early Game (Recipes 1-3)
- Healing Potion (simple 3-ingredient)
- Strength Boost (introduces timing)
- Vision Clarity (3rd ingredient practice)
- **Goal:** Learn controls, build confidence

### Mid Game (Recipes 4-8)
- Speed Elixir (temp-sensitive)
- Resistance Brew (pressure management)
- Awakening Tonic (catalyst focus)
- Advanced recipes (combine skills)
- **Goal:** Master multiple systems

### Late Game (Recipes 9+)
- Impossible Mixture (extreme challenge)
- Hidden recipes (discover through experimentation)
- Challenge orders (time pressure)
- **Goal:** High scores, optimization, mastery

---

## 🎵 AUDIO STRATEGY

**Sound Priority:** Medium (important but not primary)
- Button clicks: Satisfying mechanical sounds
- Lever pulls: Smooth sliding sounds
- Reactions: Bubbling, hissing, sparkles
- Success: Uplifting "ding" sound
- Failure: Neutral, encouraging buzz

**Music Strategy:**
- Menu: Mysterious steampunk orchestral
- Gameplay: Engaging but chill (~110 BPM)
- Success: Celebratory resolution
- Failure: Warm, encouraging

**Sources:**
- Free SFX: Freesound.org, itch.io asset store
- Music: YouTube Audio Library, Incompetech
- Godot integration: Built-in audio system (easy)

---

## 💰 MONETIZATION (POST-LAUNCH)

**Strategy:** Free-to-play with optional support
- Base game FREE on itch.io
- "Pay what you want" suggestion ($5 recommended)
- Optional ad removal ($4.99)
- Cosmetic skins ($0.99-2.99 each)
- NO pay-to-win mechanics
- Later: Steam release ($9.99)

---

## 📅 TIMELINE (12 weeks to launch)

| Week | Focus | Deliverable |
|------|-------|-------------|
| 1-2 | Foundation | Godot project, basic buttons working |
| 3-4 | Core mechanics | Recipe system, first 3 recipes playable |
| 5-6 | Polish | Assets, effects, sounds, 5 recipes |
| 7-8 | Testing | Balance, bugs, optimization |
| 9-10 | Prep | Marketing, itch.io page, final polish |
| 11-12 | Launch | Release + gather feedback |

---

## ⚙️ DEVELOPMENT PRIORITIES

### MUST HAVE
1. Satisfying button/lever feedback (non-negotiable)
2. Working chemistry system
3. Animated gauges
4. At least 3 working recipes
5. Success/failure feedback

### SHOULD HAVE
1. 5+ recipes
2. Sound effects
3. Multiple gauge types
4. Particle effects
5. Polished UI

### NICE TO HAVE
1. 10+ recipes
2. Music composition
3. Custom machine skins
4. Leaderboard
5. Story elements

---

## 🚨 CRITICAL REMINDERS

- **Scope:** Launch with 5 recipes, not 20. Can expand later.
- **Polish:** Feedback matter more than graphics. Satisfying = success.
- **Solo Dev:** Don't over-engineer. KISS (Keep It Simple, Stupid).
- **Testing:** Playtest early, get feedback, iterate fast.
- **Marketing:** The aesthetic IS the marketing. Visual unique = will get coverage.
- **Community:** Release early (beta), listen to feedback, show you care.
- **Unique Angle:** No competitor = you own the niche. Leverage this!

---

## 🎨 VISUAL REFERENCES

- Iron Nest (isometric, color, details)
- Spiritfarer (warmth, pixel art quality)
- Potion Craft (alchemy aesthetics)
- Real steampunk art (Pinterest: "steampunk control panel")
- Vintage machinery (pressure gauges, thermometers)
- Victorian era design (ornamental details)

---

## 🔗 PROJECT LINKS

- **Main Brief:** `/outputs/claude.md`
- **Task List:** `/outputs/todo.md`
- **References:** Study Iron Nest on Steam
- **Asset Store:** Godot Asset Store (free sprites/sounds)
- **Hosting:** itch.io (sign up when ready)
- **Version Control:** GitHub (free)

---

## 💡 KEY INSIGHTS

**Why This Game Works:**
1. Unique niche (no competitor exists)
2. Appeals to multiple audiences (puzzle fans, chill gamers, steampunk fans)
3. Satisfying core loop (controls feel good)
4. Scalable (5 recipes → 50+ recipes easily)
5. Low barrier to entry (easy to understand, fun to master)

**Market Advantage:**
- Iron Nest players = potential audience
- Potion Craft players = potential audience
- Opus Magnum players = potential audience
- No direct competitor = own the space
- Web-based = no install friction

**Success Metric:**
- 500+ downloads in first month = success
- 4+ star rating = quality confirmed
- 10+ hours average playtime = engagement working
- Community asks for more recipes = replayability validated

---

## 📝 NOTES FOR CLAUDE

When helping with this project:
- Always reference **Iron Nest aesthetic** for visuals
- Keep **Potion Craft's alchemy system** in mind for mechanics
- Remember **Opus Magnum's satisfaction** for feedback design
- Prioritize **satisfying feedback** over perfect graphics
- Think **web-first, mobile-second**
- Encourage **rapid iteration** over perfect planning
- Focus on **MVP launch** before feature creep
- Recommend **community feedback loops** early
- Suggest **itch.io + free-to-play** model
- Always ask: "Does this increase player satisfaction?"

---

**Last Updated:** June 2026  
**Status:** Project Brief Complete ✅ → Ready for Development 🚀
