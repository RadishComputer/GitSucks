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

	$To_Pioneer.input_event.connect(move.bind("res://Scenes/Zone_Residential/Pioneer_At_Caramel.tscn", true))
	$Door.input_event.connect(move.bind("res://Scenes/Zone_Residential/Rodneys_Door.tscn", true))

	$Fiddle.input_event.connect(fiddle_clicked)
	$Pothos.input_event.connect(pothos_clicked)
	$Boston.input_event.connect(boston_clicked)
	$Car.input_event.connect(car_clicked)
	$Pines.input_event.connect(pines_clicked)
	$Fence.input_event.connect(fence_clicked)
	$House.input_event.connect(house_clicked)
	$Bushes.input_event.connect(bushes_clicked)
	$Tree.input_event.connect(tree_clicked)

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

func car_clicked(viewport, event, shape_idx):
	if InputManager.click_release(event):
		SequenceMachine.run_sequence(["dialog:1208"], self)

func pines_clicked(viewport, event, shape_idx):
	if InputManager.click_release(event):
		SequenceMachine.run_sequence(["dialog:"], self)

func fence_clicked(viewport, event, shape_idx):
	if InputManager.click_release(event):
		SequenceMachine.run_sequence(["dialog:1211"], self)

func house_clicked(viewport, event, shape_idx):
	if InputManager.click_release(event):
		SequenceMachine.run_sequence(["dialog:1212"], self)

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

func tree_clicked(viewport, event, shape_idx):
	if InputManager.click_release(event):
		SequenceMachine.run_sequence(["dialog:1215"], self)
