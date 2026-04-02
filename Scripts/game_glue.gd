extends Control

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
	DialogManager = $Back/DialogManager
	ItemDatabase = $Back/ItemDatabase
	KnowledgeManager = $Back/KnowledgeManager
	SettingsManager = $Back/SettingsManager
	SequenceMachine = $Back/SequenceMachine
	GameState = $Back/GameState
	ClockManager = $Back/ClockManager
	NumberManager = $Back/NumberManager
	PhoneBook = $Back/PhoneBook
	Bouncer = $Back/Bouncer

	PhoneAudio = $Back/PhoneAudio
	Menu = $Back/Menu

	InputManager = $Front/InputManager
	ItemManager = $Front/ItemManager
	PortraitManager = $Front/PortraitManager
	TextBox = $Front/TextBox

func enter_tree():
	print("ENTER TREE:", self)

func load_scene(path: String):
	for child in $Middle.get_children():
		child.call_deferred("free")
	call_deferred("_finish_load_scene", path)

func _finish_load_scene(path: String):
	var scene = load(path).instantiate()
	scene.name = "Scene"
	$Middle.add_child(scene)
