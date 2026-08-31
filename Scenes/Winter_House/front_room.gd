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
	ClockManager.update_lights(self)
	ClockManager.set_front_lamp_default()
	await get_tree().process_frame
	ClockManager.church_bell()
	ClockManager.set_front_lamp_default()
	update_light_shader()

	$Front_Door.input_event.connect(front_door_clicked.bind("res://Scenes/Zone_Residential/Pioneer_At_Riverside.tscn", true))
	$Stairs.input_event.connect(stairs_clicked.bind("res://Scenes/Winter_House/Upstairs.tscn", false))
	
	$Phone.input_event.connect(phone_clicked)

	$Lamp.input_event.connect(lamp_clicked)
	$Dining_Room.input_event.connect(dining_room_clicked)
	$Umbrellas.input_event.connect(umbrella_clicked)
	$TV.input_event.connect(tv_clicked)
	$VCR.input_event.connect(vcr_clicked)
	$Movies.input_event.connect(movies_clicked)
	$Window.input_event.connect(window_clicked)
	$Pictures.input_event.connect(pictures_clicked)
	$Rug.input_event.connect(rug_clicked)
	$Mat.input_event.connect(mat_clicked)
	$Chair.input_event.connect(chair_clicked)

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

func rug_clicked(viewport, event, shape_idx):
	if InputManager.click_release(event):
		SequenceMachine.run_sequence(["dialog:1054"], self)

func mat_clicked(viewport, event, shape_idx):
	if InputManager.click_release(event):
		SequenceMachine.run_sequence(["dialog:1022"], self)

func chair_clicked(viewport, event, shape_idx):
	if InputManager.click_release(event):
		SequenceMachine.run_sequence(["dialog:1023"], self)

func phone_clicked(viewport, event, shape_idx):
	if InputManager.click_release(event):
		var middle = GameGlue.get_node_or_null("Middle")
		var return_path = ""
		
		if middle:
			for child in middle.get_children():
				if child.name == "Scene":
					return_path = child.get_meta("original_scene_path", child.scene_file_path)
					break
		ClockManager.go_to_phone(return_path)

func front_door_clicked(viewport, event, shape_idx, scene_path: String, advance_time: bool):
	if InputManager.click_release(event):
		if KnowledgeManager.secretly_knows("Front_Room_TV_On"):
			$MomButton.visible = false
			SequenceMachine.run_sequence([
				"dialog:1084",
				"action:go_back",
			], self)
			return
		ClockManager.next_scene_path = scene_path
		ClockManager.switch_scene(advance_time)
		ClockManager.set_front_lamp_default()

func stairs_clicked(viewport, event, shape_idx, scene_path: String, advance_time: bool):
	if InputManager.click_release(event):
		ClockManager.next_scene_path = scene_path
		ClockManager.switch_scene(advance_time)
		ClockManager.set_front_lamp_default()

func where_is_mom():
	var visible = ClockManager.mom_downstairs()
	$MomButton.visible = visible

func go_back():
	$MomButton.visible = true
	Bouncer.bounce($MomButton)

#Lamp Lighting

func lamp_clicked(viewport, event, shape_idx):
	if InputManager.click_release(event):
		GameGlue.FXPlayer.stream = preload("res://Sounds/LightChain.wav")
		GameGlue.FXPlayer.play()
		if KnowledgeManager.secretly_knows("Front_Lamp_On"):
			KnowledgeManager.secretly_forget("Front_Lamp_On")
		else:
			KnowledgeManager.secretly_learn("Front_Lamp_On")
		update_light_shader()

func update_light_shader():
	var enabled = KnowledgeManager.secretly_knows("Front_Lamp_On")
	$Front_Light.material.set_shader_parameter("light_enabled", enabled)
