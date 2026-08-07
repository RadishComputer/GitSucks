#Pins Entrance (opens at 11am)

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
	max_here()

	$To_Arcade.input_event.connect(move.bind("res://Scenes/Pins_Interior/Pins_Arcade.tscn", false))
	$To_Lanes.input_event.connect(move.bind("res://Scenes/Pins_Interior/Pins_Lanes.tscn", false))
	$To_Lockers.input_event.connect(move.bind("res://Scenes/Pins_Interior/Pins_Lockers.tscn", false))
	$Exit.input_event.connect(move.bind("res://Scenes/Zone_Commecial/Pioneer_At_2nd.tscn", true))

	$Phone.input_event.connect(phone_clicked)
	$Mural.input_event.connect(mural_clicked)
	$To_Backroom.input_event.connect(to_backroom_clicked)
	$For_Sale.input_event.connect(for_sale_clicked)
	$POS.input_event.connect(POS_clicked)

func go_back():
	$Max.visible = true
	Bouncer.bounce($Max)

func move(viewport, event, shape_idx, scene_path: String, advance_time: bool):
	if InputManager.click_release(event):
		if not KnowledgeManager.knows("Met_Max"):
			SequenceMachine.run_sequence([
				"action:learn:Met_Max",
				"dialog:1287",
				"action:go_back",
				"note:[center]Met Max[/center]",
			], self)
			return 

		ClockManager.next_scene_path = scene_path
		ClockManager.switch_scene(advance_time)

func mural_clicked(viewport, event, shape_idx):
	if InputManager.click_release(event):
		SequenceMachine.run_sequence(["dialog:1231"], self)

func to_backroom_clicked(viewport, event, shape_idx):
	if InputManager.click_release(event):
		SequenceMachine.run_sequence(["dialog:1232"], self)

func for_sale_clicked(viewport, event, shape_idx):
	if InputManager.click_release(event):
		SequenceMachine.run_sequence(["dialog:1233"], self)

func POS_clicked(viewport, event, shape_idx):
	if InputManager.click_release(event):
		SequenceMachine.run_sequence(["dialog:1234"], self)

func phone_clicked(viewport, event, shape_idx):
	if InputManager.click_release(event):
		if not KnowledgeManager.secretly_knows("Phone_Permission"):
				SequenceMachine.run_sequence([
				"dialog:1336",
				"action:secretly_learn:Pins_Phone"
			], self)
		else:
			var middle = GameGlue.get_node_or_null("Middle")
			var return_path = ""
		
			if middle:
				for child in middle.get_children():
					if child.name == "Scene":
						return_path = child.get_meta("original_scene_path", child.scene_file_path)
						break
			ClockManager.go_to_phone(return_path)

func max_here():
	var met_check = KnowledgeManager.knows("Met_Max")
	var arcade_off = KnowledgeManager.secretly_knows("Arcade_Off")
	$Max.visible = met_check and not arcade_off
