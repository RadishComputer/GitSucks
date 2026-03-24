#Phone Book

extends Node

var phonebook = {
	"72837": {
		"name": "Olympia Telephone Saving Service",
		"type": "call",
		"steps": [
			"dialog:1050"
		]
	},

	"12345": {
		"type": "call",
		"steps": [
			"dialog:CALL_12345_INTRO",
			"dialog:CALL_12345_RESPONSE"
		]
	},

	"77777": {
		"type": "call",
		"steps": [
			"dialog:SECRET_CALLER",
			"action:secretly_learn:Heard_Secret_Number"
		],
		"secret": true
	},

	"55555": {
		"type": "event",
		"event": "unlock_basement"
	},

	"55011": {
		"name": "Lost Cat: Cleo",
		"type": "call",
		"steps": [
			"dialog:1050"
		],
	},


}

func lookup(number: String) -> Dictionary:
	if phonebook.has(number):
		return phonebook[number]
	return { "type": "invalid" }
