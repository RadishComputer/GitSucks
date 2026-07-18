extends TextureButton

@export var item_id = "daves_radio"

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
	if KnowledgeManager.knows("Dave's_Radio_Collected"):
		queue_free()
	connect("pressed", Callable(self, "clicked"))

func clicked():
	ItemManager.add_item("daves_radio")
	if KnowledgeManager.knows("Met_Rodney") and KnowledgeManager.knows("Met_Dave"):
		SequenceMachine.run_sequence([
			"note:[center]Got Dave's Radio",
			"action:learn:Dave's_Radio_Collected",
		], self)
	else:
		SequenceMachine.run_sequence([
			"note:[center]Got Dave's Radio",
			"action:learn:Dave's_Radio_Collected",
			"dialog:1682",
		], self)
	queue_free()
