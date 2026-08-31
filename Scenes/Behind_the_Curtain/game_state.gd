extends Node2D

var game_variant = 0
var food_attributes = ["Salty", "Sour", "Spicy", "Sweet"]
var all_permutations = []
var selected_order = []
var current_day = 1
var last_scene = ""

var locker_states = {
	"locker_01": [0, 1, 2], #Max
	"locker_02": [7, 1, 5],
	"locker_03": [3, 0, 1],
	"locker_04": [2, 8, 4],
	"locker_05": [9, 3, 7], #Jeff
	"locker_06": [2, 5, 8], #Dave
	"locker_07": [1, 4, 0],
	"locker_08": [0, 6, 7], #Wes
	"locker_09": [1, 5, 4], #Roberta
	"locker_10": [0, 4, 0],
	"locker_11": [2, 1, 9],
	"locker_12": [0, 0, 0],
	"locker_13": [6, 6, 6],
	"locker_14": [4, 7, 1], #Rodney (Buzz Off)
	"locker_15": [1, 1, 4],
	"locker_16": [5, 2, 9], #Jimmy
	"locker_17": [4, 3, 8], #Jessia
	"locker_18": [7, 7, 7], #Evie
	"locker_19": [0, 0, 0],
	"locker_20": [0, 0, 9],
}

var locker_solutions = {
	"locker_01": [2, 3, 6], #Max
	"locker_02": [0, 0, 0],
	"locker_03": [0, 0, 0],
	"locker_04": [0, 0, 0],
	"locker_05": [3, 0, 0], #Jeff
	"locker_06": [0, 0, 0], #Dave
	"locker_07": [0, 0, 0],
	"locker_08": [1, 5, 0], #Wes
	"locker_09": [2, 4, 1], #Roberta
	"locker_10": [0, 0, 0],
	"locker_11": [0, 0, 0],
	"locker_12": [0, 0, 0],
	"locker_13": [0, 0, 0],
	"locker_14": [3, 6, 0], #Rodney
	"locker_15": [0, 0, 0],
	"locker_16": [5, 4, 3], #Jimmy
	"locker_17": [1, 0, 7], #Jessica
	"locker_18": [4, 9, 9], #Evie
	"locker_19": [0, 0, 0],
	"locker_20": [0, 0, 0],
}

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

#Lockers

func get_locker_state(id: String):
	return locker_states.get(id, [0, 0, 0])

func save_locker_state(id: String, state: Array):
	locker_states[id] = state

func get_locker_solution(id: String):
	return locker_solutions.get(id, [0, 0, 0])

#Export

func export_state():
	return {
		"game_variant": game_variant,
		"locker_states": locker_states,
		"current_day": current_day,
		"last_scene": last_scene
	}

func import_state(data: Dictionary):
	game_variant = data["game_variant"]
	locker_states = data["locker_states"].duplicate(true)
	current_day = data["current_day"]
	last_scene = data["last_scene"]

	all_permutations = get_permutations(food_attributes)
	selected_order = all_permutations[game_variant]
