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
	ClockManager.church_bell()

	attract_mode()

	$To_Exit.input_event.connect(move.bind("res://Scenes/Pins_Interior/Pins_Arcade.tscn", false))
	$Cabinet.input_event.connect(cabinet_clicked)

func attract_mode():
	while true:
		await get_tree().create_timer(5.0).timeout
		$Steamboat_Speedaway.visible = not $Steamboat_Speedaway.visible

func cabinet_clicked(viewport, event, shape_idx):
	if InputManager.click_release(event):
		if not KnowledgeManager.secretly_knows("Steamboat"):
			SequenceMachine.run_sequence([
				"dialog:1222",
				"action:secretly_learn:Steamboat",
			], self)
		else:
			SequenceMachine.run_sequence([
				"dialog:1223",
			], self)

func move(viewport, event, shape_idx, scene_path: String, advance_time: bool):
	if InputManager.click_release(event):
		ClockManager.next_scene_path = scene_path
		ClockManager.switch_scene(advance_time)
