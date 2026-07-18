#Roberta

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
	if KnowledgeManager.knows("Roberta_Intel"):
		intel_dialog()
		return
	if KnowledgeManager.knows("Met_Rodney"):
		rodney_dialog()
		return
	if KnowledgeManager.knows("Met_Dave"):
		dave_dialog()
		return
	if KnowledgeManager.knows("Met_Roberta"):
		roberta_dialog()
		return
	first_dialog()

func end_dialog():
	SequenceMachine.run_sequence([
		"dialog:1848",
	], self)

func radio_dialog():
		SequenceMachine.run_sequence([
		"dialog:1850",
		"action:go_back",
	], self)

func intel_dialog():
	SequenceMachine.run_sequence([
		"dialog:1846",
		"action:go_back",
	], self)

func rodney_dialog():
	SequenceMachine.run_sequence([
		"action:secretly_learn:Roberta_Intel",
		"dialog:1842",
		"action:go_back",
	], self)

func dave_dialog():
	SequenceMachine.run_sequence([
		"dialog:1839",
		"action:go_back",
	], self)

func roberta_dialog():
		SequenceMachine.run_sequence([
			"dialog:1128",
			"action:go_back",
		], self)

func first_dialog():
	SequenceMachine.run_sequence([
		"action:learn:Met_Roberta",
 		"dialog:1121",
		"action:go_back",
		"note:[center]Met Roberta[/center]",
	], self)
