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
	update_time_of_day_shader()
	#update_light_shader()
	#update_street_lights_shader()
	await get_tree().process_frame
	ClockManager.check_and_play_chime()
	
	$To_Caramel.input_event.connect(on_exit.bind("res://Scenes/Pioneer_At_Caramel.tscn", true))
	$To_Lolas.input_event.connect(on_exit.bind("res://Scenes/Lolas.tscn", false))
	$To_Cornicello.input_event.connect(on_exit.bind("res://Scenes/Cornicello.tscn", false))
	$To_Uncle_Sams.input_event.connect(on_exit.bind("res://Scenes/Uncle_Sams.tscn", false))
	$To_2nd.input_event.connect(on_exit.bind("res://Scenes/Pioneer_At_2nd.tscn", true))

func on_exit(viewport, event, shape_idx, scene_path: String, advance_time: bool):
	if InputManager.click_release(event):
		ClockManager.next_scene_path = scene_path
		if advance_time:
			ClockManager.switch_scene(true)
		else:
			get_tree().change_scene_to_file(scene_path)
		print("Going to %s" % scene_path)

#Lights

func update_time_of_day_shader():
	var tint = ClockManager.get_time_of_day_tint()
	var strength = ClockManager.get_time_of_day_strength()

	$Time_of_Day.material.set_shader_parameter("tint_color", tint)
	$Time_of_Day.material.set_shader_parameter("strength", strength)

#func update_street_lights_shader():
	#var enabled = ClockManager.street_lights()
	#$Street_Lights.material.set_shader_parameter("light_enabled", enabled)

#func update_light_shader():
	#var enabled = KnowledgeManager.secretly_knows("Front_Lamp_On")
	#$Light.material.set_shader_parameter("light_enabled", enabled)
