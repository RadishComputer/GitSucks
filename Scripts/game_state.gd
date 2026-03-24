extends Node2D

#const _csv_reference = preload("res://Dialog/dialog.csv")

var game_variant = 0
var food_attributes = ["Salty", "Sour", "Spicy", "Sweet"]
var all_permutations = []
var selected_order = []
var current_day = 1

var last_scene = null

func _ready():
	var rng = RandomNumberGenerator.new()
	rng.seed = randi()
	game_variant = rng.randi_range(0, 23)

	all_permutations = get_permutations(food_attributes)
	selected_order = all_permutations[game_variant]

	print("This game's food order:", selected_order)

func get_attribute_for_current_day() -> String:
	return selected_order[get_day_index(current_day)]

func get_day_index(day: int) -> int:
	match day:
		1: return 0  # Monday
		4: return 1  # Thursday
		5: return 2  # Friday
		6: return 3  # Saturday
		_: return -1  # Days without a request

func get_permutations(arr: Array) -> Array:
	var result = []
	permute(arr, [], result)
	return result

func permute(remaining: Array, current: Array, result: Array):
	if remaining.is_empty():
		result.append(current.duplicate())
	else:
		for i in range(remaining.size()):
			var item = remaining[i]
			var next = remaining.duplicate()
			next.remove_at(i)
			permute(next, current + [item], result)
