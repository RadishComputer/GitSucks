#Pioneer at Riverside

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
	ClockManager.distance_from_church = 7
	ClockManager.update_chime_volume()
	ClockManager.update_clock_display()
	await get_tree().process_frame
	ClockManager.church_bell()
	ClockManager.update_lights(self)
	update_upstairs_shader()

	$Door.input_event.connect(move.bind("res://Scenes/Winter_House/Front_Room.tscn", false))
	$To_Caramel.input_event.connect(move.bind("res://Scenes/Zone_Residential/Pioneer_At_Caramel.tscn", true))
	
	$Neighbors.input_event.connect(neighbors_clicked)
	$GPS.input_event.connect(gps_clicked)
	$Mountains.input_event.connect(mountains_clicked)
	$Tree.input_event.connect(tree_clicked)
	$Bush.input_event.connect(bush_clicked)
	$Nature.input_event.connect(nature_clicked)


func move(viewport, event, shape_idx, scene_path: String, advance_time: bool):
	if InputManager.click_release(event):
		ClockManager.next_scene_path = scene_path
		ClockManager.switch_scene(advance_time)

func neighbors_clicked(viewport, event, shape_idx):
	if InputManager.click_release(event):
		if KnowledgeManager.knows("Found_Joey"):
			SequenceMachine.run_sequence(["dialog:1969"], self)
		else:
			SequenceMachine.run_sequence(["dialog:1086"], self)

func gps_clicked(viewport, event, shape_idx):
	if InputManager.click_release(event):
		if not KnowledgeManager.secretly_knows("GPS"):
			SequenceMachine.run_sequence([
				"dialog:1087",
				"action:secretly_learn:GPS",
			], self)
		else:
			SequenceMachine.run_sequence([
				"dialog:1088",
				"action:secretly_forget:GPS"
			], self)

func mountains_clicked(viewport, event, shape_idx):
	if InputManager.click_release(event):
		SequenceMachine.run_sequence(["dialog:1089"], self)

func tree_clicked(viewport, event, shape_idx):
	if InputManager.click_release(event):
		SequenceMachine.run_sequence(["dialog:1090"], self)

func nature_clicked(viewport, event, shape_idx):
	if InputManager.click_release(event):
		SequenceMachine.run_sequence(["dialog:1049"], self)

func bush_clicked(viewport, event, shape_idx):
	if InputManager.click_release(event):
		if KnowledgeManager.knows("Found_Joey"):
			know_joey()
		else:
			no_joey()

func know_joey():
	SequenceMachine.run_sequence(["dialog:1969"], self)

func no_joey():
	if ClockManager.hours >= 14 and ClockManager.hours < 16:
		GameGlue.ClockManager.next_scene_path = "res://Scenes/Cats/joey.tscn"
		GameGlue.ClockManager.switch_scene(false)
	else:
		SequenceMachine.run_sequence(["dialog:1086"], self)

#Lights

func update_upstairs_shader():
	var enabled = KnowledgeManager.secretly_knows("Upstairs_Lamp_On")
	$Upstairs_Lamp.material.set_shader_parameter("light_enabled", enabled)
