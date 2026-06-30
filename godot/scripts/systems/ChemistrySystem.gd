extends Node

## Recipe definitions and brew evaluation.
## A brew succeeds when all conditions are held for the required time.

const RECIPES: Array[Dictionary] = [
	{
		"name": "Healing Potion",
		"desc": "Soothe wounds and restore vitality.",
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
		"min_temp": 30.0,
		"max_temp": 55.0,
		"min_pressure": 0.5,
		"max_pressure": 3.5,
		"brew_time": 40.0,
		"needs_catalyst": false,
		"filter": 1,  # AZURE
	},
]

func is_in_valid_range(temp: float, pressure: float, recipe_index: int) -> bool:
	var r: Dictionary = RECIPES[recipe_index]
	return (
		temp >= r["min_temp"] and temp <= r["max_temp"] and
		pressure >= r["min_pressure"] and pressure <= r["max_pressure"]
	)

func evaluate_brew(brew_time_in_range: float, purity: float, used_catalyst: bool, filter: int, recipe_index: int) -> Dictionary:
	var r: Dictionary = RECIPES[recipe_index]
	var success := brew_time_in_range >= r["brew_time"] and purity > 0.0
	if success and r["needs_catalyst"] and not used_catalyst:
		success = false
	if success and r["filter"] != -1 and filter != r["filter"]:
		success = false
	var quality := "POOR"
	if purity >= 80.0:
		quality = "PERFECT"
	elif purity >= 50.0:
		quality = "GOOD"
	elif purity >= 20.0:
		quality = "POOR"
	return {"success": success, "quality": quality, "purity": purity}
