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
	
	$To_Arcade.input_event.connect(move.bind("res://Scenes/Pins_Interior/Pins_Arcade.tscn", false))
	$To_Lanes.input_event.connect(move.bind("res://Scenes/Pins_Interior/Pins_Lanes.tscn", false))
	$To_Lockers.input_event.connect(move.bind("res://Scenes/Pins_Interior/Pins_Lockers.tscn", false))
	$Exit.input_event.connect(move.bind("res://Scenes/Zone_Commecial/Pioneer_At_2nd.tscn", false))

	$Phone.input_event.connect(phone_clicked)

	if KnowledgeManager.knows("Met_Max"):
		$Max.visible = true
	else:
		$Max.visible = false

func go_back():
	$Max.visible = true
	Bouncer.bounce($Max)

func move(viewport, event, shape_idx, scene_path: String, advance_time: bool):
	if InputManager.click_release(event):

		if not KnowledgeManager.knows("Met_Max"):

			SequenceMachine.run_sequence([
				"action:learn:Met_Max",
				"dialog:1300",
				"action:go_back",
				"note:[center]Met Max[/center]",
			], self)
			return 

		ClockManager.next_scene_path = scene_path
		ClockManager.switch_scene(advance_time)

func phone_clicked():
	print("HI")
