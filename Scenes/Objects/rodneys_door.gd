#Rodneys Door Object

extends TextureButton

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
	connect("pressed", Callable(self, "clicked"))

func rodney_arrives():
	$"../Rodney_at_Home".visible = true
	$".".visible = false
	Bouncer.bounce($"../Rodney_at_Home")

func go_back():
	$"../Rodney_at_Home".visible = true
	Bouncer.bounce($"../Rodney_at_Home")

func clicked():
	if not KnowledgeManager.secretly_knows("Dave_Anything"):
		knock_loop()
		return
	if KnowledgeManager.secretly_knows("Show_Off"):
		knock_loop()
		return
	if ClockManager.rodney_here("lunch") or ClockManager.rodney_here("evening"):
		home_dialog()
		return

	knock_loop()

func knock_loop():#No answer
	if KnowledgeManager.secretly_knows("Rodney_Knock"):
		SequenceMachine.run_sequence([
			"dialog:1434",
			"action:secretly_forget:Rodney_Knock",
		], self)
	else:
		SequenceMachine.run_sequence([
			"dialog:1433",
			"action:secretly_learn:Rodney_Knock",
		], self)

func home_dialog():
	if not KnowledgeManager.knows("Met_Rodney"):
		SequenceMachine.run_sequence([
			"action:learn:Met_Rodney",
			"dialog:1435",
            "note:[center]Met Rodney"
		], self)
		return

	if not KnowledgeManager.knows("Got_Daves_Radio"):
		if ClockManager.rodney_here("evening"):
			SequenceMachine.run_sequence([
				"dialog:1490",#What do you want no?
				"action:rodney_arrives",
			], self)
		if ClockManager.rodney_here("lunch"):
			SequenceMachine.run_sequence([
				"dialog:1454",#Buzz off
			], self)
		return

	if not KnowledgeManager.secretly_knows("Show_Off"):
		SequenceMachine.run_sequence([
			"dialog:1460",
			"action:secretly_learn:Show_Off",
		], self)
		return
