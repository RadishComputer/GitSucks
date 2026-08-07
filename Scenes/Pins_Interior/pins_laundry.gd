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
	laundry_day()
	await get_tree().process_frame
	ClockManager.church_bell()
	
	$To_Lockers.input_event.connect(move.bind("res://Scenes/Pins_Interior/Pins_Lockers.tscn", false))

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

func move(viewport, event, shape_idx, scene_path: String, advance_time: bool):
	if InputManager.click_release(event):
		ClockManager.next_scene_path = scene_path
		ClockManager.switch_scene(advance_time)

func soap_despenser_clicked(viewport, event, shape_idx):
	if InputManager.click_release(event):
		SequenceMachine.run_sequence(["dialog:1720"], self)

func painting_clicked(viewport, event, shape_idx):
	if InputManager.click_release(event):
		SequenceMachine.run_sequence(["dialog:1721"], self)

func detergent_clicked(viewport, event, shape_idx):
	if InputManager.click_release(event):
		SequenceMachine.run_sequence(["dialog:1722"], self)

func basket_clicked(viewport, event, shape_idx):
	if InputManager.click_release(event):
		if not KnowledgeManager.secretly_knows("Basket"):
			SequenceMachine.run_sequence([
				"dialog:1724",
				"action:secretly_learn:Basket",
			], self)
		else:
			SequenceMachine.run_sequence([
				"dialog:1725",
				"action:secretly_forget:Basket",
			], self)

func seats_clicked(viewport, event, shape_idx):
	if InputManager.click_release(event):
		SequenceMachine.run_sequence(["dialog:1726"], self)

func washing_machine_clicked(viewport, event, shape_idx):
	if InputManager.click_release(event):
		SequenceMachine.run_sequence(["dialog:1727"], self)

func coin0_clicked(viewport, event, shape_idx):
	empty_coin(event)

func coin1_clicked(viewport, event, shape_idx):
	empty_coin(event)

func coin2_clicked(viewport, event, shape_idx):
	empty_coin(event)

func coin3_clicked(viewport, event, shape_idx):
	empty_coin(event)

func coin4_clicked(viewport, event, shape_idx):
	empty_coin(event)

func coin5_clicked(viewport, event, shape_idx):
	empty_coin(event)

func coin6_clicked(viewport, event, shape_idx):
	empty_coin(event)

func coin7_clicked(viewport, event, shape_idx):
	empty_coin(event)

func coin8_clicked(viewport, event, shape_idx):
	empty_coin(event)

func coin9_clicked(viewport, event, shape_idx):
	empty_coin(event)

func coin10_clicked(viewport, event, shape_idx):
	empty_coin(event)

func coin11_clicked(viewport, event, shape_idx):
	empty_coin(event)

func empty_coin(event):
	if InputManager.click_release(event):
		SequenceMachine.run_sequence(["dialog:1728"], self)

func laundry_day():
	var visible = ClockManager.wheres_sammy()
	$Sammy.visible = visible
