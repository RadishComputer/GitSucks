#Sammy

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

func go_back():
	self.visible = true
	Bouncer.bounce(self)

func clicked():
	self.visible = false

	if not KnowledgeManager.knows("Met_Sammy"):
		SequenceMachine.run_sequence([
			"action:learn:Met_Sammy",
 			"dialog:1344",
			"action:go_back",
			"note:[center]Met Sammy"
		], self)
		return
	elif not KnowledgeManager.secretly_knows("Newt"):
		SequenceMachine.run_sequence([
			"dialog:1345",
			"action:go_back",
		], self)
	else:
		SequenceMachine.run_sequence([
			"dialog:1358",
			"action:go_back",
		], self)
