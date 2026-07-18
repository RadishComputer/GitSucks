#Jimmy

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
	if KnowledgeManager.knows("Jimmy_Intel"):
		intel_dialog()
		return
	if KnowledgeManager.knows("Met_Rodney"):
		rodney_dialog()
		return
	if KnowledgeManager.secretly_knows("Jimmy_the_Fish"):
		partner_dialog()
		return
	if KnowledgeManager.secretly_knows("Good_Luck"):
		jimmy_the_knife_dialog()
		return
	if KnowledgeManager.knows("Met_Dave"):
		dave_dialog()
		return
	if KnowledgeManager.knows("Met_Jimmy"):
		jimmy_dialog()
		return
	first_dialog()

func end_dialog():
	SequenceMachine.run_sequence([
		"dialog:1836",
	], self)

func intel_dialog():
	SequenceMachine.run_sequence([
		"dialog:1834",
		"action:go_back",
	], self)

func rodney_dialog():
	if KnowledgeManager.secretly_knows("Jimmy_the_Fish"):
		SequenceMachine.run_sequence([
			"action:secretly_learn:Jimmy_Intel",
			"dialog:1814",
			"action:go_back",
		], self)
	else:
		SequenceMachine.run_sequence([
			"action:secretly_learn:Jimmy_Intel",
			"dialog:1828",
			"action:go_back",
		], self)

func partner_dialog():
	SequenceMachine.run_sequence([
		"dialog:1812",
		"action:go_back",
	], self)

func jimmy_the_knife_dialog():
	SequenceMachine.run_sequence([
		"action:secretly_learn:Jimmy_the_Fish",
		"dialog:1803",
		"action:go_back",
	], self)

func dave_dialog():
	SequenceMachine.run_sequence([
		"action:secretly_learn:Good_Luck",
		"dialog:1802",
		"action:go_back",
	], self)

func jimmy_dialog():
	SequenceMachine.run_sequence([
		"dialog:1142",
		"action:go_back",
	], self)

func first_dialog():
	SequenceMachine.run_sequence([
		"action:learn:Met_Jimmy",
 		"dialog:1137",
		"action:go_back",
		"note:[center]Met Jimmy[/center]",
	], self)
	return
