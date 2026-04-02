#Gina

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
	connect("pressed", Callable(self, "on_item_clicked"))

func go_back():
	self.visible = true
	Bouncer.bounce(self)

func on_item_clicked():
	self.visible = false

	if not KnowledgeManager.knows("Met_Gina"):
		SequenceMachine.run_sequence([
			"action:learn:Met_Gina",
 			"dialog:1258",
			"action:go_back",
			"note:[center]Met Gina"
		], self)
		return
	else:
		SequenceMachine.run_sequence([
			"shopdialog:1260",
			"action:go_back",
		], self)
