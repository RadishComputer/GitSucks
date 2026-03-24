extends Node

signal phonebook_update

var numbers = []  # or a dictionary if you want labels

func add_number(num: String):
	if not numbers.has(num):
		numbers.append(num)
		emit_signal("phonebook_updated")

func get_numbers():
	return numbers
