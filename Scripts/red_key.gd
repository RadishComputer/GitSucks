extends TextureButton

var Phone

@export var item_id = "red_key"

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
	if KnowledgeManager.knows("Red_Key_Collected"):
		queue_free()
	connect("pressed", Callable(self, "on_item_clicked"))

func on_item_clicked():
	ItemManager.add_item("red_key")
	SequenceMachine.run_sequence([
		"note:[center]Got A Red Key[/center]",
		"action:learn:Red_Key_Collected"
	], self)
	queue_free()
