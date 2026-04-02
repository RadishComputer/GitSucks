# /\_/\
#( o.o )

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
	update_time_of_day_shader()
	await get_tree().process_frame
	ClockManager.check_and_play_chime()

	$Back.input_event.connect(_on_exit.bind("res://Scenes/Pioneer_At_Caramel.tscn", true))
	$Number.input_event.connect(number_clicked)
	$Cleo.input_event.connect(cleo_clicked)

func _on_exit(viewport, event, shape_idx, scene_path: String, advance_time: bool):
	if InputManager.click_release(event):
		ClockManager.next_scene_path = scene_path
		if advance_time:
			ClockManager.switch_scene(true)
		else:
			get_tree().change_scene_to_file(scene_path)
		print("Going to %s" % scene_path)

func cleo_clicked(viewport, event, shape_idx):
	if InputManager.click_release(event):
		if not KnowledgeManager.knows("Look For Cleo"):
			if not KnowledgeManager.secretly_knows("Cleo"):
				SequenceMachine.run_sequence([
					"dialog:1114",
					"action:secretly_learn:Cleo"
				], self)
			else:
				SequenceMachine.run_sequence([
					"action:learn:Look For Cleo",
					"dialog:1115",
					"note:[center]Look For Cleo",
				], self)
		SequenceMachine.run_sequence([
				"dialog:1113",
			], self)

func number_clicked(viewport, event, shape_idx):
	if InputManager.click_release(event):
		if not "55011" in NumberManager.get_numbers():
			SequenceMachine.run_sequence([
				"dialog:1109",
				"action:add_number:55011",
				"note:[center]Lost Cat: Cleo - 55011",
			], self)
			return
		SequenceMachine.run_sequence([
			"dialog:1110"
		], self)


#Lights

func update_time_of_day_shader():
	var tint = ClockManager.get_time_of_day_tint()
	var strength = ClockManager.get_time_of_day_strength()

	$Time_of_Day.material.set_shader_parameter("tint_color", tint)
	$Time_of_Day.material.set_shader_parameter("strength", strength)
