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
	street_kids()
	ClockManager.update_lights(self)
	await get_tree().process_frame
	ClockManager.church_bell()

	$Dave.visible = KnowledgeManager.knows("Met_Dave") and not KnowledgeManager.knows("Radio_Returned")

	$Oak_Tree.input_event.connect(oak_tree_clicked)
	$Grass.input_event.connect(grass_clicked)
	$Town.input_event.connect(town_clicked)
	$Mountains.input_event.connect(mountains_clicked)
	$Pine_Tree.input_event.connect(pine_tree_clicked)
	$Lamp.input_event.connect(lamp_clicked)

	$To_Riverside.input_event.connect(move.bind("res://Scenes/Zone_Residential/Pioneer_At_Riverside.tscn", true))
	$To_Main.input_event.connect(move.bind("res://Scenes/Zone_Commecial/Pioneer_At_Main.tscn", true))
	$Cat_Flyer.input_event.connect(move.bind("res://Scenes/Zone_Another/Cat_Flyer.tscn", false))
	$To_Rodneys_House.input_event.connect(move.bind("res://Scenes/Zone_Residential/Rodneys_House.tscn", true))

func dave_arrives():
	$Dave.visible = true
	Bouncer.bounce($Dave)

func oak_tree_clicked(viewport, event, shape_idx):
	if InputManager.click_release(event):
		if not KnowledgeManager.secretly_knows("Acorn"):
			SequenceMachine.run_sequence([
				"action:secretly_learn:Acorn",
 				"dialog:1770",
			], self)
			return
		else:
			SequenceMachine.run_sequence([
				"dialog:1771",
			], self)

func grass_clicked(viewport, event, shape_idx):
	if InputManager.click_release(event):
		if KnowledgeManager.secretly_knows("Acorn") and not KnowledgeManager.knows("Acorn_Collected"):
			GameGlue.ItemManager.add_item("acorn")
			GameGlue.SequenceMachine.run_sequence([
				"note:[center]Got An Acorn",
				"action:learn:Acorn_Collected"
			], self)


func town_clicked(viewport, event, shape_idx):
	if InputManager.click_release(event):
		SequenceMachine.run_sequence(["dialog:1773"], self)

func mountains_clicked(viewport, event, shape_idx):
	if InputManager.click_release(event):
		SequenceMachine.run_sequence(["dialog:1774"], self)

func pine_tree_clicked(viewport, event, shape_idx):
	if InputManager.click_release(event):
		SequenceMachine.run_sequence(["dialog:1775"], self)

func lamp_clicked(viewport, event, shape_idx):
	if InputManager.click_release(event):
		SequenceMachine.run_sequence(["dialog:1776"], self)

func move(viewport, event, shape_idx, scene_path, advance_time):
	if InputManager.click_release(event):
		if not KnowledgeManager.knows("Met_Dave") \
		and KnowledgeManager.knows("Met_Evie") \
		and KnowledgeManager.knows("Met_Jessica") \
		and KnowledgeManager.knows("Met_Jimmy") \
		and KnowledgeManager.knows("Met_Roberta") \
		and KnowledgeManager.knows("Met_Wes"):

			SequenceMachine.run_sequence([
				"action:learn:Met_Dave",
				"action:learn:Find_the_Radio",
				"dialog:1149",
				"action:dave_arrives",
				"note:[center]Met Dave[/center]",
				"note:[center]Find the Radio[/center]",
			], self)

			return 

		ClockManager.next_scene_path = scene_path
		ClockManager.switch_scene(advance_time)


func street_kids():
	var visible = ClockManager.day_one_kids()
	$Evie.visible = visible
	$Jessica.visible = visible
	$Jimmy.visible = visible
	$Roberta.visible = visible
	$Wes.visible = visible
