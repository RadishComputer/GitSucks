#Bear Room Drawer

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
	ClockManager.distance_from_church = 8
	ClockManager.update_chime_volume()
	ClockManager.update_clock_display()
	await get_tree().process_frame
	ClockManager.check_and_play_chime()
	update_time_of_day_shader()
	update_light_shader()

	$Back.input_event.connect(on_exit.bind("res://Scenes/Bear_Room.tscn", true))
	$Book.input_event.connect(book_clicked)
	$Lamp.input_event.connect(lamp_clicked)


	if not KnowledgeManager.knows("Pocket_Knife_Collected"):
		$Pocket_Knife.visible = true
	if not KnowledgeManager.knows("Red_Key_Collected"):
		$Red_Key.visible = true

func book_clicked(viewport, event, shape_idx):
	if GameGlue.InputManager.click_release(event):
		if not GameGlue.KnowledgeManager.secretly_knows("Book_Look"):
			GameGlue.SequenceMachine.run_sequence([
				"action:secretly_learn:Book_Look",
				"dialog:1035"
			], self)
		else:
			GameGlue.SequenceMachine.run_sequence(["dialog:1036"], self)

func on_exit(viewport, event, shape_idx, scene_path: String, advance_time: bool):
	if GameGlue.InputManager.click_release(event):
		GameGlue.ClockManager.next_scene_path = scene_path
		if advance_time:
			GameGlue.ClockManager.switch_scene(true)
		else:
			get_tree().change_scene_to_file(scene_path)
		print("Going to %s" % scene_path)

#Day Lighting

func update_time_of_day_shader():
	var tint = GameGlue.ClockManager.get_time_of_day_tint()
	var strength = GameGlue.ClockManager.get_time_of_day_strength()

	$Time_of_Day.material.set_shader_parameter("tint_color", tint)
	$Time_of_Day.material.set_shader_parameter("strength", strength)

#Lamp Lighting

func lamp_clicked(viewport, event, shape_idx):
	if GameGlue.InputManager.click_release(event):
		if GameGlue.KnowledgeManager.secretly_knows("Lamp_On"):
			GameGlue.KnowledgeManager.secretly_forget("Lamp_On")
		else:
			GameGlue.KnowledgeManager.secretly_learn("Lamp_On")
		update_light_shader()

func update_light_shader():
	var enabled = GameGlue.KnowledgeManager.secretly_knows("Lamp_On")
	$Lamp_Light.material.set_shader_parameter("light_enabled", enabled)
