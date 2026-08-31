#Intro

extends Control

@onready var Intro1 = $Intro_1
@onready var Intro2 = $Intro_2
@onready var Intro3 = $Intro_3

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
	GameGlue.DialogManager.reset_dialog_state()
	await get_tree().create_timer(1.0).timeout

	Intro1.visible = true
	await wait_for_click()
	Intro1.visible = false

	SequenceMachine.run_sequence(["dialog:1986"], self)
	await SequenceMachine.sequence_finished

	Intro2.visible = true
	await wait_for_click()
	Intro2.visible = false

	SequenceMachine.run_sequence(["dialog:1989"], self)
	await SequenceMachine.sequence_finished

	Intro3.visible = true
	await wait_for_click()
	Intro3.visible = false

	finish_scene()

func wait_for_click():
	await get_tree().process_frame
	while true:
		await get_tree().process_frame
		if Input.is_action_just_released("click"):
			return

func finish_scene():
	GameGlue.load_scene("res://Scenes/Behind_the_Curtain/Summery.tscn")
