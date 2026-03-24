extends Node

var PhoneAudio
var DialogManager
var ItemDatabase
var Bouncer
var GameState
var ClockManager
var NumberManager
var KnowledgeManager
var SettingsManager
var PhoneBook
var SequenceMachine
var Menu

var InputManager
var ItemManager
var PortraitManager
var TextBox

func _ready():
	load_ui()
	load_first_scene()

func enter_tree():
	print("ENTER TREE:", self)

func load_ui():
	DialogManager = load("res://Scripts/DialogManager.gd")
	ItemDatabase = load("res://Scripts/item_database.gd")
	KnowledgeManager = load("res://Scripts/KnowledgeManager.gd")
	SettingsManager = load("res://Scripts/settings_manager.gd")
	SequenceMachine = load("res://Scripts/sequence_machine.gd")
	GameState = load("res://Scripts/game_state.gd")
	ClockManager = load("res://Scripts/ClockManager.gd")
	NumberManager = load("res://Scripts/number_manager.gd")
	PhoneBook = load("res://Scripts/phone_book.gd")
	Bouncer = load("res://Scripts/bouncer.gd")

	
	PhoneAudio = load("res://Scenes/Phone_Audio.tscn")
	Menu = load("res://Scenes/Menu.tscn")

	InputManager = load("res://Scenes/Input_Manager.tscn")
	ItemManager = load("res://Scenes/Item_Manager.tscn")
	PortraitManager = load("res://Scenes/Portrait_Manager.tscn")
	TextBox = load("res://Scenes/TextBox.tscn")

	DialogManager = load("res://Scripts/DialogManager.gd")

	$Back.add_child(PhoneAudio)
	$Back.add_child(DialogManager)
	$Back.add_child(ItemDatabase)
	$Back.add_child(Bouncer)
	$Back.add_child(GameState)
	$Back.add_child(ClockManager)
	$Back.add_child(NumberManager)
	$Back.add_child(KnowledgeManager)
	$Back.add_child(SettingsManager)
	$Back.add_child(PhoneBook)
	$Back.add_child(SequenceMachine)
	$Back.add_child(Menu)

	$Front.add_child(InputManager)
	$Front.add_child(ItemManager)
	$Front.add_child(PortraitManager)
	$Front.add_child(TextBox)

func load_first_scene():
	load_scene("res://Scenes/Summery.tscn")

func load_scene(path: String):
	for child in get_children():
		if child.name == "Scene":
			remove_child(child)
			child.queue_free()

	var scene = load(path).instantiate()
	scene.name = "Scene"
	$Middle.add_child(scene)
