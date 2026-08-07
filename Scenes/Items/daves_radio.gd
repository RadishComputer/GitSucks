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
	connect("pressed", Callable(self, "clicked"))

func go_back():
	$"../Rodney_at_Arcade".visible = true
	Bouncer.bounce($"../Rodney_at_Arcade")

func clicked():
	if KnowledgeManager.secretly_knows("Arcade_Off"):
		GameGlue.ItemManager.add_item("daves_radio")
		GameGlue.SequenceMachine.run_sequence([
			"note:[center]Got Dave's Radio[/center]",
			"action:learn:Dave's_Radio_Collected",
			"action:secretly_learn:Distract_Rodney",
		], self)
		self.visible = false
		return
	if KnowledgeManager.secretly_knows("Arcade_On"):
		$"../Rodney_at_Arcade".visible = false
		GameGlue.SequenceMachine.run_sequence([
			"dialog:1428",
			"action:go_back",
		], self)
		return
	else:
		$"../Rodney_at_Arcade".visible = false
		GameGlue.SequenceMachine.run_sequence([
			"dialog:1424",
			"action:go_back",
		], self)
		return
