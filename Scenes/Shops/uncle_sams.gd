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
	
	$Exit.input_event.connect(move.bind("res://Scenes/Zone_Commecial/Pioneer_At_Main.tscn", true))

	$Menu.input_event.connect(menu_clicked)

func go_back():
	$Gina.visible = true
	Bouncer.bounce($Gina)

func menu_clicked(viewport, event, shape_idx):
	if InputManager.click_release(event):
		$Gina.visible = false
		SequenceMachine.run_sequence([
			"shopdialog:1260",
			"action:go_back",
		], self)

func move(viewport, event, shape_idx, scene_path: String, advance_time: bool):
	if InputManager.click_release(event):
		ClockManager.next_scene_path = scene_path
		ClockManager.switch_scene(advance_time)
