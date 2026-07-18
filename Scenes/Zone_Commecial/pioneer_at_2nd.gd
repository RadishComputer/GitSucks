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
	ClockManager.distance_from_church = 4
	ClockManager.update_chime_volume()
	ClockManager.update_clock_display()
	update_time_of_day_shader()
	#update_light_shader()
	#update_street_lights_shader()
	await get_tree().process_frame
	ClockManager.check_and_play_chime()

	$Monets_Door.input_event.connect(monets_door_clicked)
	$Monets_Sign.input_event.connect(monets_sign_clicked)
	$Pins_Sign.input_event.connect(pins_sign_clicked)
	$Bucket.input_event.connect(bucket_clicked)
	$Trashcan.input_event.connect(trashcan_clicked)
	$Flowers.input_event.connect(flowers_clicked)
	$Florist.input_event.connect(florist_clicked)
	$Ashtray.input_event.connect(ashtray_clicked)
	$Bush.input_event.connect(bush_clicked)

	$To_Pins.input_event.connect(move.bind("res://Scenes/Pins_Interior/Pins_Desk.tscn", false))
	$To_Main.input_event.connect(move.bind("res://Scenes/Zone_Commecial/Pioneer_At_Main.tscn", true))

func monets_door_clicked(viewport, event, shape_idx):
	if InputManager.click_release(event):
		SequenceMachine.run_sequence(["dialog:1730"], self)

func monets_sign_clicked(viewport, event, shape_idx):
	if InputManager.click_release(event):
		if not KnowledgeManager.secretly_knows("Monets_Tried"):
			SequenceMachine.run_sequence([
				"dialog:1731",
				"action:secretly_learn:Monets_Tried"
			], self)
		else:
			SequenceMachine.run_sequence(["dialog:1732"], self)

func pins_sign_clicked(viewport, event, shape_idx):
	if InputManager.click_release(event):
		SequenceMachine.run_sequence(["dialog:1733"], self)

func bucket_clicked(viewport, event, shape_idx):
	if InputManager.click_release(event):
		SequenceMachine.run_sequence(["dialog:1735"], self)

func trashcan_clicked(viewport, event, shape_idx):
	if InputManager.click_release(event):
		SequenceMachine.run_sequence(["dialog:1736"], self)

func flowers_clicked(viewport, event, shape_idx):
	if InputManager.click_release(event):
		if not KnowledgeManager.secretly_knows("Flowers"):
			SequenceMachine.run_sequence([
				"dialog:1737",
				"action:secretly_learn:Flowers",
			], self)
		else:
			SequenceMachine.run_sequence([
				"dialog:1738",
				"action:secretly_forget:Flower",
			], self)

func florist_clicked(viewport, event, shape_idx):
	if InputManager.click_release(event):
		SequenceMachine.run_sequence(["dialog:1739"], self)

func ashtray_clicked(viewport, event, shape_idx):
	if InputManager.click_release(event):
		if not KnowledgeManager.secretly_knows("Ashtray_Tried"):
			SequenceMachine.run_sequence([
				"dialog:1740",
				"action:secretly_learn:Ashtray_Tried"
			], self)
		else:
			SequenceMachine.run_sequence(["dialog:1741"], self)

func bush_clicked(viewport, event, shape_idx):
	if InputManager.click_release(event):
		SequenceMachine.run_sequence(["dialog:1742"], self)

func move(viewport, event, shape_idx, scene_path, advance_time):
	if InputManager.click_release(event):
		ClockManager.next_scene_path = scene_path
		ClockManager.switch_scene(advance_time)

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
