extends Control

@onready var PhoneAudio = GameGlue.PhoneAudio
@onready var PhoneBook = GameGlue.PhoneBook
@onready var DialogManager = GameGlue.DialogManager
@onready var ItemDatabase = GameGlue.ItemDatabase
@onready var ClockManager = GameGlue.ClockManager
@onready var GameState = GameGlue.GameState
@onready var NumberManager = GameGlue.NumberManager
@onready var KnowledgeManager = GameGlue.KnowledgeManager
@onready var SettingsManager = GameGlue.SettingsManager
@onready var SequenceMachine = GameGlue.SequenceMachine
@onready var Bouncer = GameGlue.Bouncer
@onready var Menu = GameGlue.Menu
@onready var InputManager = GameGlue.InputManager
@onready var PortraitManager = GameGlue.PortraitManager
@onready var ItemManager = GameGlue.ItemManager
@onready var TextBox = GameGlue.TextBox

func _ready():
	ClockManager.distance_from_church = 5
	ClockManager.update_chime_volume()
	ClockManager.update_clock_display()
	await get_tree().process_frame
	ClockManager.check_and_play_chime()
	
	$To_Desk.input_event.connect(move.bind("res://Scenes/Pins_Interior/Pins_Desk.tscn", false))
	$To_QoE.input_event.connect(move.bind("res://Scenes/Pins_Interior/Arcade_Queens_Of_Egypt.tscn", false))
	$To_SS.input_event.connect(move.bind("res://Scenes/Pins_Interior/Arcade_Steamboat_Speedway.tscn", false))
	$To_TTO.input_event.connect(move.bind("res://Scenes/Pins_Interior/Arcade_Take_This_Outback.tscn", false))
	$To_TBM.input_event.connect(move.bind("res://Scenes/Pins_Interior/Arcade_Travlin_Banjo_Man.tscn", false))
	$To_AA.input_event.connect(move.bind("res://Scenes/Pins_Interior/Arcade_Ape_Architecht.tscn", false))

func move(viewport, event, shape_idx, scene_path: String, advance_time: bool):
	if InputManager.click_release(event):
		ClockManager.next_scene_path = scene_path
		ClockManager.switch_scene(advance_time)
