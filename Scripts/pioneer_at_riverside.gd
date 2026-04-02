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
	update_time_of_day_shader()
	update_light_shader()
	update_street_lights_shader()
	update_upstairs_shader()
	await get_tree().process_frame
	ClockManager.check_and_play_chime()

	$Door.input_event.connect(on_exit.bind("res://Scenes/Front_Room.tscn", false))
	$To_Caramel.input_event.connect(on_exit.bind("res://Scenes/Pioneer_At_Caramel.tscn", true))
	$Neighbors.input_event.connect(neighbors_clicked)
	$GPS.input_event.connect(gps_clicked)
	$Mountains.input_event.connect(mountains_clicked)
	$Tree.input_event.connect(tree_clicked)


func on_exit(viewport, event, shape_idx, scene_path: String, advance_time: bool):
	if InputManager.click_release(event):
		ClockManager.next_scene_path = scene_path
		if advance_time:
			ClockManager.switch_scene(true)
		else:
			get_tree().change_scene_to_file(scene_path)
		print("Going to %s" % scene_path)

func neighbors_clicked(viewport, event, shape_idx):
	if InputManager.click_release(event):
		SequenceMachine.run_sequence(["dialog:1086"], self)

func gps_clicked(viewport, event, shape_idx):
	if InputManager.click_release(event):
		if not KnowledgeManager.secretly_knows("GPS"):
			SequenceMachine.run_sequence([
				"dialog:1071",
				"action:secretly_learn:GPS",
			], self)
		else:
			SequenceMachine.run_sequence([
				"dialog:1072",
				"action:secretly_forget:GPS"
			], self)

func mountains_clicked(viewport, event, shape_idx):
	if InputManager.click_release(event):
		SequenceMachine.run_sequence(["dialog:1089"], self)

func tree_clicked(viewport, event, shape_idx):
	if InputManager.click_release(event):
		SequenceMachine.run_sequence(["dialog:1090"], self)

#Lights

func update_time_of_day_shader():
	var tint = ClockManager.get_time_of_day_tint()
	var strength = ClockManager.get_time_of_day_strength()

	$Time_of_Day.material.set_shader_parameter("tint_color", tint)
	$Time_of_Day.material.set_shader_parameter("strength", strength)

func update_street_lights_shader():
	var enabled = ClockManager.street_lights()
	$Street_Lights.material.set_shader_parameter("light_enabled", enabled)

func update_light_shader():
	var enabled = KnowledgeManager.secretly_knows("Front_Lamp_On")
	$Light.material.set_shader_parameter("light_enabled", enabled)

func update_upstairs_shader():
	var enabled = KnowledgeManager.secretly_knows("Upstairs_Lamp_On")
	$Upstairs.material.set_shader_parameter("light_enabled", enabled)
