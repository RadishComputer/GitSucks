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
	ClockManager.check_and_play_chime()
	
	$To_Lockers.input_event.connect(on_exit.bind("res://Scenes/Pins_Lockers.tscn", false))

	$Soap_Despenser.input_event.connect(soap_despenser_clicked)
	$Painting.input_event.connect(painting_clicked)
	$Detergent.input_event.connect(detergent_clicked)
	$Basket.input_event.connect(basket_clicked)
	$Seats.input_event.connect(seats_clicked)
	$Washing_Machine.input_event.connect(washing_machine_clicked)
	$Coin0.input_event.connect(coin0_clicked)
	$Coin1.input_event.connect(coin1_clicked)
	$Coin2.input_event.connect(coin2_clicked)
	$Coin3.input_event.connect(coin3_clicked)
	$Coin4.input_event.connect(coin4_clicked)
	$Coin5.input_event.connect(coin5_clicked)
	$Coin6.input_event.connect(coin6_clicked)
	$Coin7.input_event.connect(coin7_clicked)
	$Coin8.input_event.connect(coin8_clicked)
	$Coin9.input_event.connect(coin9_clicked)
	$Coin10.input_event.connect(coin10_clicked)
	$Coin11.input_event.connect(coin11_clicked)


func on_exit(viewport, event, shape_idx, scene_path: String, advance_time: bool):
	if InputManager.click_release(event):
		ClockManager.next_scene_path = scene_path
		if advance_time:
			ClockManager.switch_scene(true)
		else:
			get_tree().change_scene_to_file(scene_path)
		print("Going to %s" % scene_path)

func soap_despenser_clicked():
	print("hi")

func painting_clicked():
	print("hi")

func detergent_clicked():
	print("hi")

func basket_clicked():
	print("hi")

func seats_clicked():
	print("hi")

func washing_machine_clicked():
	print("hi")

func coin0_clicked():
	print("hi")

func coin1_clicked():
	print("hi")

func coin2_clicked():
	print("hi")

func coin3_clicked():
	print("hi")

func coin4_clicked():
	print("hi")

func coin5_clicked():
	print("hi")

func coin6_clicked():
	print("hi")

func coin7_clicked():
	print("hi")

func coin8_clicked():
	print("hi")

func coin9_clicked():
	print("hi")

func coin10_clicked():
	print("hi")

func coin11_clicked():
	print("hi")
