#Front Room

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

var front_lamp_on: bool

func _ready():
	ClockManager.distance_from_church = 8
	ClockManager.update_chime_volume()
	ClockManager.update_clock_display()
	where_is_mom()
	update_time_of_day_shader()
	ClockManager.set_front_lamp_default()
	await get_tree().process_frame
	ClockManager.check_and_play_chime()
	ClockManager.set_front_lamp_default()
	update_light_shader()

	$Front_Door.input_event.connect(front_door_clicked)

	$Stairs.input_event.connect(on_exit.bind("res://Scenes/Upstairs.tscn", true))
	$Phone.input_event.connect(phone_clicked)

	$Lamp.input_event.connect(lamp_clicked)
	$Dining_Room.input_event.connect(dining_room_clicked)
	$Umbrellas.input_event.connect(umbrella_clicked)
	$TV.input_event.connect(tv_clicked)
	$VCR.input_event.connect(vcr_clicked)
	$Movies.input_event.connect(movies_clicked)
	$Window.input_event.connect(window_clicked)
	$Pictures.input_event.connect(pictures_clicked)


func dining_room_clicked(viewport, event, shape_idx):
	if InputManager.click_release(event):
		SequenceMachine.run_sequence(["dialog:1078"], self)

func umbrella_clicked(viewport, event, shape_idx):
	if InputManager.click_release(event):
		SequenceMachine.run_sequence(["dialog:1079"], self)

func tv_clicked(viewport, event, shape_idx):
	if InputManager.click_release(event):
		SequenceMachine.run_sequence(["dialog:1080"], self)

func vcr_clicked(viewport, event, shape_idx):
	if InputManager.click_release(event):
		SequenceMachine.run_sequence(["dialog:1081"], self)

func movies_clicked(viewport, event, shape_idx):
	if InputManager.click_release(event):
		SequenceMachine.run_sequence(["dialog:1082"], self)

func window_clicked(viewport, event, shape_idx):
	if InputManager.click_release(event):
		SequenceMachine.run_sequence(["dialog:1083"], self)

func pictures_clicked(viewport, event, shape_idx):
	if InputManager.click_release(event):
		SequenceMachine.run_sequence(["dialog:1077"], self)

func front_door_clicked(viewport, event, shape_idx):
	if InputManager.click_release(event):
		if KnowledgeManager.secretly_knows("Front_Room_TV_On"):
			$MomButton.visible = false
			SequenceMachine.run_sequence([
				"dialog:1084",
				"action:go_back",
			], self)
			return

		on_exit(viewport, event, shape_idx, "res://Scenes/Pioneer_At_Riverside.tscn", true)


func on_exit(viewport, event, shape_idx, scene_path: String, advance_time: bool):
	if InputManager.click_release(event):
		if KnowledgeManager.secretly_knows("Food_Received"):
			get_tree().change_scene_to_file("res://Scenes/demo_end.tscn")
		else:
			ClockManager.next_scene_path = scene_path
			if advance_time:
				ClockManager.switch_scene(true)
			else:
				get_tree().change_scene_to_file(scene_path)
			print("Going to %s" % scene_path)
			ClockManager.set_front_lamp_default()

func update_time_of_day_shader():
	var tint = ClockManager.get_time_of_day_tint()
	var strength = ClockManager.get_time_of_day_strength()

	$Time_of_Day.material.set_shader_parameter("tint_color", tint)
	$Time_of_Day.material.set_shader_parameter("strength", strength)

func where_is_mom():
	var visible = ClockManager.mom_downstairs()
	$MomButton.visible = visible

func go_back():
	$MomButton.visible = true
	Bouncer.bounce($MomButton)

#Lamp Lighting

func lamp_clicked(viewport, event, shape_idx):
	if InputManager.click_release(event):
		if KnowledgeManager.secretly_knows("Front_Lamp_On"):
			KnowledgeManager.secretly_forget("Front_Lamp_On")
		else:
			KnowledgeManager.secretly_learn("Front_Lamp_On")
		update_light_shader()

func update_light_shader():
	var enabled = KnowledgeManager.secretly_knows("Front_Lamp_On")
	$Light.material.set_shader_parameter("light_enabled", enabled)

func phone_clicked():
	print ("WOW")
