#Rodneys Door Scene

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
	ClockManager.distance_from_church = 6
	ClockManager.update_chime_volume()
	ClockManager.update_clock_display()
	ClockManager.update_lights(self)
	await get_tree().process_frame
	ClockManager.church_bell()

	$Back.input_event.connect(move.bind("res://Scenes/Zone_Residential/Rodneys_House.tscn", true))

	$Fiddle.input_event.connect(fiddle_clicked)
	$Pothos.input_event.connect(pothos_clicked)
	$Boston.input_event.connect(boston_clicked)
	$Mat.input_event.connect(mat_clicked)
	$Bushes.input_event.connect(bushes_clicked)
	$Pot.input_event.connect(pot_clicked)
	$Mailbox.input_event.connect(mailbox_clicked)

func move(viewport, event, shape_idx, scene_path: String, advance_time: bool):
	if InputManager.click_release(event):
		ClockManager.next_scene_path = scene_path
		ClockManager.switch_scene(advance_time)


func fiddle_clicked(viewport, event, shape_idx):
	if InputManager.click_release(event):
		SequenceMachine.run_sequence(["dialog:1205"], self)

func pothos_clicked(viewport, event, shape_idx):
	if InputManager.click_release(event):
		SequenceMachine.run_sequence(["dialog:1206"], self)

func boston_clicked(viewport, event, shape_idx):
	if InputManager.click_release(event):
		SequenceMachine.run_sequence(["dialog:1207"], self)

func mat_clicked(viewport, event, shape_idx):
	if InputManager.click_release(event):
		SequenceMachine.run_sequence(["dialog:1214"], self)

func bushes_clicked(viewport, event, shape_idx):
	if InputManager.click_release(event):
		if not KnowledgeManager.secretly_knows("Bush"):
			SequenceMachine.run_sequence([
				"dialog:1213",
				"action:secretly_learn:Bush",
			], self)
		else:
			SequenceMachine.run_sequence([
				"dialog:1214",
				"action:secretly_forget:Bush",
			], self)

func pot_clicked(viewport, event, shape_idx):
	if InputManager.click_release(event):
		if not KnowledgeManager.secretly_knows("Pot"):
			SequenceMachine.run_sequence([
				"dialog:1217",
				"action:secretly_learn:Pot",
			], self)
		else:
			SequenceMachine.run_sequence([
				"dialog:1218",
			], self)

func mailbox_clicked(viewport, event, shape_idx):
	if InputManager.click_release(event):
		SequenceMachine.run_sequence(["dialog:1216"], self)
