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
	update_street_lights_shader()
	await get_tree().process_frame
	ClockManager.check_and_play_chime()

	if KnowledgeManager.knows("Met_Dave"):
		$Dave.visible = true
	else:
		$Dave.visible = false

	$To_Riverside.input_event.connect(on_exit.bind("res://Scenes/Pioneer_At_Riverside.tscn", true))
	$To_Main.input_event.connect(on_exit.bind("res://Scenes/Pioneer_At_Main.tscn", true))
	$Cat_Flyer.input_event.connect(on_exit.bind("res://Scenes/Cat_Flyer.tscn", false))
	$To_Rodneys_House.input_event.connect(on_exit.bind("res://Scenes/Rodneys_House.tscn", false))

func dave_arrives():
	$Dave.visible = true
	Bouncer.bounce($Dave)

func on_exit(viewport, event, shape_idx, scene_path: String, advance_time: bool):
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

func update_street_lights_shader():
	var enabled = ClockManager.street_lights()
	$Street_Lights.material.set_shader_parameter("light_enabled", enabled)

func update_light_shader():
	var enabled = KnowledgeManager.secretly_knows("Front_Lamp_On")
	$Light.material.set_shader_parameter("light_enabled", enabled)
