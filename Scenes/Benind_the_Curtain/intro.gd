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

var dialog_line_1 = "I don't want to go to a stinkin’ small town for vacation."
var dialog_line_2 = "I wanted to go to the city, or to the beach."
var dialog_line_3 = "I love my grandparents but they're sooo boring."
var dialog_line_4 = "There is nothing to do here."
var dialog_line_5 = "They don't even have cable."
var dialog_line_6 = "I’m just going to spend the whole time sleeping."

func _ready():
	GameGlue.DialogManager.reset_dialog_state()
	await get_tree().create_timer(1.0).timeout
	Intro1.visible = false
	Intro2.visible = false
	Intro3.visible = false
	GameGlue.TextBox.hide_dialog()

	await get_tree().process_frame

	Intro1.visible = true
	await wait_for_click()

	Intro1.visible = false
	GameGlue.TextBox.set_skin("intro")
	GameGlue.TextBox.show_dialog_text(dialog_line_1)
	await GameGlue.TextBox.dialog_advanced
	GameGlue.TextBox.show_dialog_text(dialog_line_2)
	await GameGlue.TextBox.dialog_advanced
	GameGlue.TextBox.show_dialog_text(dialog_line_3)
	await GameGlue.TextBox.dialog_advanced


	Intro2.visible = true
	await wait_for_click()

	Intro2.visible = false
	GameGlue.TextBox.set_skin("intro")
	GameGlue.TextBox.show_dialog_text(dialog_line_4)
	await GameGlue.TextBox.dialog_advanced
	GameGlue.TextBox.show_dialog_text(dialog_line_5)
	await GameGlue.TextBox.dialog_advanced
	GameGlue.TextBox.show_dialog_text(dialog_line_6)
	await GameGlue.TextBox.dialog_advanced

	Intro3.visible = true
	await wait_for_click()

	finish_scene()

func wait_for_click():
	await get_tree().process_frame
	while true:
		await get_tree().process_frame
		if Input.is_action_just_released("click"):
			return

func finish_scene():
	GameGlue.load_scene("res://Scenes/Benind_the_Curtain/Summery.tscn")
