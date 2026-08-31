extends Node

signal phonebook_update

var numbers = []

func add_number(num: String):
	if not numbers.has(num):
		numbers.append(num)
		emit_signal("phonebook_update")

func get_numbers():
	return numbers

#Export

func export_state():
	return {
		"numbers": numbers
	}

func import_state(data):
	numbers = data.get("numbers", [])
