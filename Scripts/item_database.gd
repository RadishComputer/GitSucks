extends Node

var items = {
	"pocket_knife": {
		"name": "Pocket Knife",
		"type": "tool",
		"description": ".",
		"value": 0
	},
	"red_key": {
		"name": "Red Key",
		"type": "key",
		"description": ".",
		"value": 0
	},
	"little_guy": {
		"name": "Little Guy",
		"type": "toy",
		"description": ".",
		"value": 0
	},
	"daves_radio": {
		"name": "Dave's Radio",
		"type": "radio",
		"unlocks": ["radio"],
		"description": ".",
		"value": 0
	},
	"chicken_scarpariello": {
		"name": "Chicken Scarpariello",
		"type": "food",
		"attribute": ["earthy", "salty", "sour", "spicy"],
		"description": ".",
		"value": 10.49
	},
	"margherita_pizza": {
		"name": "Margherita Pizza",
		"type": "food",
		"attribute": ["salty", "sweet"],
		"description": ".",
		"value": 7.99
	},
		"chicken_and_mushroom_penne": {
		"name": "Pollo F Penne",
		"type": "food",
		"attribute": ["creamy", "earthy", "salty"],
		"description": ".",
		"value": 9.99
	},
	"chili_shrimp_fettuccine": {
		"name": "Chili Shrimp Fettuccine",
		"type": "food",
		"attribute": ["creamy", "salty", "spicy"],
		"description": ".",
		"value": 12.49
	},
	"spaghetti_bolognese": {
		"name": "Spaghetti Bolognese",
		"type": "food",
		"attribute": ["earthy", "salty", "sweet"],
		"description": ".",
		"value": 9.49
	},
	"cheese_burger": {
		"name": "Cheese Burger",
		"type": "food",
		"attribute": ["salty"],
		"description": ".",
		"value": 6.49
	},
	"chicken_fried_steak": {
		"name": "Chicken Fried Steak",
		"type": "food",
		"attribute": ["creamy", "salty"],
		"description": ".",
		"value": 8.49
	},
	"ruben_sandwich": {
		"name": "Ruben Sandwich",
		"type": "food",
		"attribute": ["earthy", "salty", "sour"],
		"description": ".",
		"value": 7.49
	},
	"bowl_of_chili": {
		"name": "Bowl of Chili",
		"type": "food",
		"attribute": ["earthy", "salty", "spicy"],
		"description": ".",
		"value": 5.99
	},
	"breakfast_platter": {
		"name": "Breakfast Platter",
		"type": "food",
		"attribute": ["salty", "sweet"],
		"description": ".",
		"value": 7.49
	},
	"adobo": {
		"name": "Adobo",
		"type": "food",
		"attribute": ["earthy", "salty", "sour"],
		"description": ".",
		"value": 7.49
	},
	"pancit": {
		"name": "Pancit",
		"type": "food",
		"attribute": ["earthy", "salty"],
		"description": ".",
		"value": 6.99
	},
	"sinigang": {
		"name": "Sinigang",
		"type": "food",
		"attribute": ["earthy", "salty", "sour"],
		"description": ".",
		"value": 8.49
	},
	"dinuguan": {
		"name": "Dinuguan",
		"type": "food",
		"attribute": ["earthy", "salty"],
		"description": ".",
		"value": 6.99
	},
	"sapin_sapin": {
		"name": "Sapin Sapin",
		"type": "food",
		"attribute": ["sweet"],
		"description": ".",
		"value": 4.49
	},
}

func get_item(id: String) -> Dictionary:
	return items.get(id, {})

#func get_item_texture(id: String) -> Texture2D:
	#return load("res://Art/Beta/Items/%s.png" % id)

func get_item_texture(id: String) -> Texture2D:
	var path = "res://Art/Beta/Items/%s.png" % id
	var tex = load(path)
	if tex:
		return tex
	var item = get_item(id)
	if item.has("type") and item.type == "food":
		return load("res://Art/Beta/Items/Food.png")
	return load("res://Art/Beta/Items/Test.png")
