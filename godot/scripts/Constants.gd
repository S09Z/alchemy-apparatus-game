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
