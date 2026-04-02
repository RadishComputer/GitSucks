extends TextureButton

@export var item_id = "pocket_knife"

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
	if GameGlue.KnowledgeManager.knows("Pocket_Knife_Collected"):
		queue_free()
	connect("pressed", Callable(self, "on_item_clicked"))

func on_item_clicked():
	GameGlue.ItemManager.add_item("pocket_knife")
	GameGlue.SequenceMachine.run_sequence([
		"note:[center]Got A Pocket Knife[/center]",
		"action:learn:Pocket_Knife_Collected"
	], self)
	queue_free()
