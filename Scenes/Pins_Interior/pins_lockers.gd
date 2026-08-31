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
	ClockManager.update_lights(self)
	await get_tree().process_frame
	ClockManager.church_bell()
	
	$Side_Exit.input_event.connect(side_exit_clicked)
	$Window.input_event.connect(window_clicked)
	$Bowling_Ball.input_event.connect(bowling_ball_clicked)
	$Towel.input_event.connect(towel_clicked)
	$Bench.input_event.connect(bench_clicked)
	$Light.input_event.connect(light_clicked)
	$Switch.input_event.connect(switch_clicked)
	
	$To_Laundry.input_event.connect(move.bind("res://Scenes/Pins_Interior/Pins_Laundry.tscn", false))
	$To_Desk.input_event.connect(move.bind("res://Scenes/Pins_Interior/Pins_Desk.tscn", false))
	$Locker_01.input_event.connect(move.bind("res://Scenes/Pins_Interior/Lockers/Locker_01.tscn", false))
	$Locker_02.input_event.connect(move.bind("res://Scenes/Pins_Interior/Lockers/Locker_02.tscn", false))
	$Locker_03.input_event.connect(move.bind("res://Scenes/Pins_Interior/Lockers/Locker_03.tscn", false))
	$Locker_04.input_event.connect(move.bind("res://Scenes/Pins_Interior/Lockers/Locker_04.tscn", false))
	$Locker_05.input_event.connect(move.bind("res://Scenes/Pins_Interior/Lockers/Locker_05.tscn", false))
	$Locker_06.input_event.connect(move.bind("res://Scenes/Pins_Interior/Lockers/Locker_06.tscn", false))
	$Locker_07.input_event.connect(move.bind("res://Scenes/Pins_Interior/Lockers/Locker_07.tscn", false))
	$Locker_08.input_event.connect(move.bind("res://Scenes/Pins_Interior/Lockers/Locker_08.tscn", false))
	$Locker_09.input_event.connect(move.bind("res://Scenes/Pins_Interior/Lockers/Locker_09.tscn", false))
	$Locker_10.input_event.connect(move.bind("res://Scenes/Pins_Interior/Lockers/Locker_10.tscn", false))
	$Locker_11.input_event.connect(move.bind("res://Scenes/Pins_Interior/Lockers/Locker_11.tscn", false))
	$Locker_12.input_event.connect(move.bind("res://Scenes/Pins_Interior/Lockers/Locker_12.tscn", false))
	$Locker_13.input_event.connect(move.bind("res://Scenes/Pins_Interior/Lockers/Locker_13.tscn", false))
	$Locker_14.input_event.connect(move.bind("res://Scenes/Pins_Interior/Lockers/Locker_14.tscn", false))
	$Locker_15.input_event.connect(move.bind("res://Scenes/Pins_Interior/Lockers/Locker_15.tscn", false))
	$Locker_16.input_event.connect(move.bind("res://Scenes/Pins_Interior/Lockers/Locker_16.tscn", false))
	$Locker_17.input_event.connect(move.bind("res://Scenes/Pins_Interior/Lockers/Locker_17.tscn", false))
	$Locker_18.input_event.connect(move.bind("res://Scenes/Pins_Interior/Lockers/Locker_18.tscn", false))
	$Locker_19.input_event.connect(move.bind("res://Scenes/Pins_Interior/Lockers/Locker_19.tscn", false))
	$Locker_20.input_event.connect(move.bind("res://Scenes/Pins_Interior/Lockers/Locker_20.tscn", false))

func side_exit_clicked(viewport, event, shape_idx):
	if InputManager.click_release(event):
		SequenceMachine.run_sequence(["dialog:1670"], self)

func window_clicked(viewport, event, shape_idx):
	if InputManager.click_release(event):
		if KnowledgeManager.knows("Found_Creamy_Color"):
			know_cat()
		else:
			no_cat()

func know_cat():
	SequenceMachine.run_sequence(["dialog:1979"], self)

func no_cat():
	if ItemManager.cash >= 10.00:
		GameGlue.ClockManager.next_scene_path = "res://Scenes/Cats/creamy_color.tscn"
		GameGlue.ClockManager.switch_scene(false)
	else:
		SequenceMachine.run_sequence(["dialog:1671"], self)


func bowling_ball_clicked(viewport, event, shape_idx):
	if InputManager.click_release(event):
		if not KnowledgeManager.secretly_knows("Bowling_Ball"):
			SequenceMachine.run_sequence([
				"dialog:1672",
				"action:secretly_learn:Bowling_Ball",
			], self)
		else:
			SequenceMachine.run_sequence([
				"dialog:1673",
				"action:secretly_forget:Bowling_Ball",
			], self)

func towel_clicked(viewport, event, shape_idx):
	if InputManager.click_release(event):
		SequenceMachine.run_sequence(["dialog:1674"], self)

func bench_clicked(viewport, event, shape_idx):
	if InputManager.click_release(event):
		SequenceMachine.run_sequence(["dialog:1676"], self)

func light_clicked(viewport, event, shape_idx):
	if InputManager.click_release(event):
		SequenceMachine.run_sequence(["dialog:1677"], self)

func switch_clicked(viewport, event, shape_idx):
	if InputManager.click_release(event):
		SequenceMachine.run_sequence(["dialog:1678"], self)

func move(viewport, event, shape_idx, scene_path: String, advance_time: bool):
	if InputManager.click_release(event):
		ClockManager.next_scene_path = scene_path
		ClockManager.switch_scene(advance_time)
