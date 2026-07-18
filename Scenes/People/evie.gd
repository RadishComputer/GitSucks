#Evie

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
	if KnowledgeManager.knows("Radio_Returned"):
		end_dialog()
		return
	if ItemManager.inventory_has_item("daves_radio"):
		radio_dialog()
		return
	if KnowledgeManager.knows("Met_Rodney"):
		rodney_dialog()
		return
	if KnowledgeManager.knows("Met_Dave"):
		dave_dialog()
		return
	if KnowledgeManager.knows("Met_Evie"):
		evie_dialog()
		return
	first_dialog()

func end_dialog():
	SequenceMachine.run_sequence([
		"dialog:1783",
	], self)

func radio_dialog():
		SequenceMachine.run_sequence([
		"dialog:1784",
		"action:go_back",
	], self)

func rodney_dialog():
	SequenceMachine.run_sequence([
		"dialog:1781",
		"action:go_back",
	], self)

func dave_dialog():
	SequenceMachine.run_sequence([
		"dialog:1780",
		"action:go_back",
	], self)

func evie_dialog():
	SequenceMachine.run_sequence([
		"dialog:1135",
		"action:go_back",
	], self)

func first_dialog():
	SequenceMachine.run_sequence([
		"action:learn:Met_Evie",
 		"dialog:1130",
		"action:go_back",
		"note:[center]Met Evie[/center]",
	], self)
