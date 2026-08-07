#Pioneer at Main

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
	ClockManager.update_lights(self)

	$Uncle_Sams.input_event.connect(uncle_sams_clicked)
	$Ladder.input_event.connect(ladder_clicked)
	$Street_Sign.input_event.connect(street_sign_clicked)
	$Lolas.input_event.connect(lolas_clicked)
	$The_Hitching_Post.input_event.connect(the_hitching_post_clicked)
	$Stop_Sign.input_event.connect(stop_sign_clicked)
	$Cornicello.input_event.connect(cornicello_clicked)
	$Window.input_event.connect(window_clicked)
	$Phone.input_event.connect(phone_clicked)

	$To_Caramel.input_event.connect(move.bind("res://Scenes/Zone_Residential/Pioneer_At_Caramel.tscn", true))
	$To_2nd.input_event.connect(move.bind("res://Scenes/Zone_Commecial/Pioneer_At_2nd.tscn", true))
	$To_Lolas.input_event.connect(move.bind("res://Scenes/Shops/Lolas.tscn", false))
	$To_Cornicello.input_event.connect(move.bind("res://Scenes/Shops/Cornicello.tscn", false))
	$To_Uncle_Sams.input_event.connect(move.bind("res://Scenes/Shops/Uncle_Sams.tscn", false))

	$To_The_Hitching_Post.input_event.connect(to_the_hitching_post)

func uncle_sams_clicked(viewport, event, shape_idx):
	if InputManager.click_release(event):
		SequenceMachine.run_sequence(["dialog:1745"], self)

func ladder_clicked(viewport, event, shape_idx):
	if InputManager.click_release(event):
		SequenceMachine.run_sequence(["dialog:1748"], self)

func street_sign_clicked(viewport, event, shape_idx):
	if InputManager.click_release(event):
		SequenceMachine.run_sequence(["dialog:1749"], self)

func lolas_clicked(viewport, event, shape_idx):
	if InputManager.click_release(event):
		SequenceMachine.run_sequence(["dialog:1750"], self)

func the_hitching_post_clicked(viewport, event, shape_idx):
	if InputManager.click_release(event):
		SequenceMachine.run_sequence(["dialog:1754"], self)

func stop_sign_clicked(viewport, event, shape_idx):
	if InputManager.click_release(event):
		SequenceMachine.run_sequence(["dialog:1757"], self)

func cornicello_clicked(viewport, event, shape_idx):
	if InputManager.click_release(event):
		SequenceMachine.run_sequence(["dialog:1758"], self)

func window_clicked(viewport, event, shape_idx):
	if InputManager.click_release(event):
		if not KnowledgeManager.secretly_knows("Spooky_Window"):
			SequenceMachine.run_sequence([
				"dialog:1761",
				"action:secretly_learn:Spooky_Window"
			], self)
		else:
			SequenceMachine.run_sequence(["dialog:1762"], self)

func to_the_hitching_post(viewport, event, shape_idx):
	if InputManager.click_release(event):
		SequenceMachine.run_sequence(["dialog:1763"], self)

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

func move(viewport, event, shape_idx, scene_path: String, advance_time: bool):
	if InputManager.click_release(event):
		ClockManager.next_scene_path = scene_path
		ClockManager.switch_scene(advance_time)
