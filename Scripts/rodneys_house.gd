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
	update_light_shader()
	await get_tree().process_frame
	ClockManager.check_and_play_chime()

	$To_Pioneer.input_event.connect(on_exit.bind("res://Scenes/Pioneer_At_Caramel.tscn", true))
	$Door.input_event.connect(on_exit.bind("res://Scenes/Rodneys_Door.tscn", false))

	$Porch_Plant.input_event.connect(porch_plant_clicked)
	$Hanging_Plant1.input_event.connect(hanging_plant1_clicked)
	$Hanging_Plant2.input_event.connect(hanging_plant2_clicked)
	$Car.input_event.connect(car_clicked)


func on_exit(viewport, event, shape_idx, scene_path: String, advance_time: bool):
	if InputManager.click_release(event):
		ClockManager.next_scene_path = scene_path
		if advance_time:
			ClockManager.switch_scene(true)
		else:
			get_tree().change_scene_to_file(scene_path)

		print("Going to %s" % scene_path)

func porch_plant_clicked(viewport, event, shape_idx):
	if InputManager.click_release(event):
		SequenceMachine.run_sequence(["dialog:0000"], self)

func hanging_plant1_clicked(viewport, event, shape_idx):
	if InputManager.click_release(event):
		SequenceMachine.run_sequence(["dialog:0000"], self)

func hanging_plant2_clicked(viewport, event, shape_idx):
	if InputManager.click_release(event):
		SequenceMachine.run_sequence(["dialog:0000"], self)

func car_clicked(viewport, event, shape_idx):
	if InputManager.click_release(event):
		SequenceMachine.run_sequence(["dialog:0000"], self)


#Lights

func update_time_of_day_shader():
	var tint = ClockManager.get_time_of_day_tint()
	var strength = ClockManager.get_time_of_day_strength()

	$Time_of_Day.material.set_shader_parameter("tint_color", tint)
	$Time_of_Day.material.set_shader_parameter("strength", strength)

func update_light_shader():
	var enabled = ClockManager.street_lights()
	$Light.material.set_shader_parameter("light_enabled", enabled)
