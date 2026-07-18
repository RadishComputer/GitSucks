#Pins Arcade

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
	where_is_rodney()

	KnowledgeManager.knowledge_learned.connect(on_knowledge_learned)

	if KnowledgeManager.secretly_knows("Arcade_Off"):
		KnowledgeManager.secretly_forget("Arcade_Off")
		SequenceMachine.run_sequence([
			"dialog:1508",
			], self)
		KnowledgeManager.secretly_learn("Arcade_On")
	
	$Exit.input_event.connect(exit_clicked.bind("res://Scenes/Pins_Interior/Pins_Desk.tscn", false))
	$To_QoE.input_event.connect(move.bind("res://Scenes/Pins_Interior/Arcade_Queens_Of_Egypt.tscn", false))
	$To_SS.input_event.connect(move.bind("res://Scenes/Pins_Interior/Arcade_Steamboat_Speedway.tscn", false))
	$To_TTO.input_event.connect(move.bind("res://Scenes/Pins_Interior/Arcade_Take_This_Outback.tscn", false))
	$To_TBM.input_event.connect(move.bind("res://Scenes/Pins_Interior/Arcade_Travlin_Banjo_Man.tscn", false))
	$To_AA.input_event.connect(move.bind("res://Scenes/Pins_Interior/Arcade_Ape_Architecht.tscn", false))


	$Carpet.input_event.connect(carpet_clicked)
	$Wall.input_event.connect(wall_clicked)
	$Claw.input_event.connect(claw_clicked)
	$Toy.input_event.connect(toy_clicked)
	$Toy_Coin.input_event.connect(toy_coin_clicked)
	$Game.input_event.connect(game_clicked)
	$Outlets.input_event.connect(outlets_clicked)

func exit_clicked(viewport, event, shape_idx, scene_path, advance_time):
	if InputManager.click_release(event):
		if not KnowledgeManager.secretly_knows("Rodney_Confrontation") and KnowledgeManager.knows("Dave's_Radio_Collected"):
				SequenceMachine.run_sequence([
					"dialog:1500",
					"action:secretly_learn:Rodney_Confrontation",
				], self)
				return
		ClockManager.next_scene_path = scene_path
		ClockManager.switch_scene(advance_time)

func move(viewport, event, shape_idx, scene_path, advance_time):
	if InputManager.click_release(event):
		ClockManager.next_scene_path = scene_path
		ClockManager.switch_scene(advance_time)

func carpet_clicked(viewport, event, shape_idx):
	if InputManager.click_release(event):
		if not KnowledgeManager.secretly_knows("Carpet_Tried"):
			SequenceMachine.run_sequence([
				"dialog:1659",
				"action:secretly_learn:Carpet_Tried"
			], self)
		else:
			SequenceMachine.run_sequence(["dialog:1660"], self)

func wall_clicked(viewport, event, shape_idx):
	if InputManager.click_release(event):
		SequenceMachine.run_sequence(["dialog:1661"], self)

func claw_clicked(viewport, event, shape_idx):
	if InputManager.click_release(event):
		if not KnowledgeManager.secretly_knows("Claw"):
			SequenceMachine.run_sequence([
				"dialog:1663",
				"action:secretly_learn:Claw",
			], self)
		else:
			SequenceMachine.run_sequence([
				"dialog:1664",
				"action:secretly_forget:Claw",
			], self)

func toy_clicked(viewport, event, shape_idx):
	if InputManager.click_release(event):
		SequenceMachine.run_sequence(["dialog:1665"], self)

func toy_coin_clicked(viewport, event, shape_idx):
	if InputManager.click_release(event):
		if not KnowledgeManager.knows("Sticker_Collected"):
			ItemManager.add_item("sticker")
			SequenceMachine.run_sequence([
				"dialog:1666",
				"note:[center]Summer Found A Sticker[/center]",
				"action:learn:Sticker_Collected"
			], self)
		else:
			SequenceMachine.run_sequence(["dialog:1044"], self)

func game_clicked(viewport, event, shape_idx):
	if InputManager.click_release(event):
		SequenceMachine.run_sequence(["dialog:1667"], self)

func outlets_clicked(viewport, event, shape_idx):
	if InputManager.click_release(event):
		if $Rodney_at_Arcade.visible:
			rodney_outlet(viewport, event, shape_idx)
			return
		power_outlet(viewport, event, shape_idx)

func rodney_outlet(viewport, event, shape_idx):
	if InputManager.click_release(event):
		if not KnowledgeManager.secretly_knows("Dave_Anything"):
			SequenceMachine.run_sequence([
				"dialog:1430",
			],self)
			return
		if KnowledgeManager.secretly_knows("Arcade_On"):
			SequenceMachine.run_sequence([
				"dialog:1428",
			],self)
			return
		if not KnowledgeManager.secretly_knows("Arcade_Off"):
			power_outlet(viewport, event, shape_idx)
			SequenceMachine.run_sequence([
				"action:secretly_learn:Arcade_Off",
				"dialog:1425",
			],self)
			$Rodney_at_Arcade.visible = false
			return

		SequenceMachine.run_sequence([
			"dialog:1429",
		],self)

func power_outlet(viewport, event, shape_idx):
	if KnowledgeManager.secretly_knows("Arcade_On"):
		SequenceMachine.run_sequence([
			"dialog:1430",
		],self)
		return
	if not KnowledgeManager.secretly_knows("Arcade_Off"):
		$Screens.visible = false
		KnowledgeManager.secretly_learn("Arcade_Off")
	else:
		$Screens.visible = true
		KnowledgeManager.secretly_forget("Arcade_Off")

func where_is_rodney():
	var rodney_time = ClockManager.rodney_here("arcade_am") or ClockManager.rodney_here("arcade_pm")
	var disrupted = KnowledgeManager.knows("Dave's_Radio_Collected") or KnowledgeManager.secretly_knows("Annoy_Rodney")
	$Rodney_at_Arcade.visible = rodney_time and not disrupted
	$Daves_Radio.visible = rodney_time and not disrupted

func on_knowledge_learned(id: String):
	if id == "Annoy_Rodney":
		where_is_rodney()
