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

func go_back():
	self.visible = true
	Bouncer.bounce(self)

func clicked():
	if ClockManager.rodney_here("lunch"):
		lunch_dialog()
		return

	if ClockManager.rodney_here("evening"):
		evening_dialog()
		return

	if not KnowledgeManager.secretly_knows("Rodney_Knock"):
		SequenceMachine.run_sequence([
			"dialog:1433",
			"action:secretly_learn:Rodney_Knock",
		], self)
	else:
		SequenceMachine.run_sequence([
			"dialog:1434",
			"action:secretly_forget:Rodney_Knock",
		], self)

func lunch_dialog():
	if not KnowledgeManager.secretly_knows("Dave_Anything"):
		if not KnowledgeManager.secretly_knows("Rodney_Knock"):
			SequenceMachine.run_sequence([
				"dialog:1433",
				"action:secretly_learn:Rodney_Knock",
			], self)
		else:
			SequenceMachine.run_sequence([
				"dialog:1434",
				"action:secretly_forget:Rodney_Knock",
			], self)
		
	elif not KnowledgeManager.knows("Met_Rodney"):
		SequenceMachine.run_sequence([
			"action:learn:Met_Rodney",
 			"dialog:1435",
			"note:[center]Met Rodney"
		], self)
		return
	elif not KnowledgeManager.knows("Got_Daves_Radio"):
		SequenceMachine.run_sequence([
			"dialog:1454",
		], self)
	elif not KnowledgeManager.secretly_knows("Show_Off"):
		SequenceMachine.run_sequence([
			"dialog:1460",
			"action:secretly_learn:Show_Off",
		], self)
	else:
		SequenceMachine.run_sequence([
			"dialog:1072",
		], self)

func evening_dialog():
	if not KnowledgeManager.secretly_knows("Dave_Anything"):
		if not KnowledgeManager.secretly_knows("Rodney_Knock"):
			SequenceMachine.run_sequence([
				"dialog:1433",
				"action:secretly_learn:Rodney_Knock",
			], self)
		else:
			SequenceMachine.run_sequence([
				"dialog:1434",
				"action:secretly_forget:Rodney_Knock",
			], self)
		
	elif not KnowledgeManager.knows("Met_Rodney"):
		SequenceMachine.run_sequence([
			"action:learn:Met_Rodney",
 			"dialog:1435",
			"note:[center]Met Rodney"
		], self)
		return
	elif not KnowledgeManager.knows("Got_Daves_Radio"):
		SequenceMachine.run_sequence([
			"dialog:1483",
			"action:secretly_learn:Ready_To_Trade",
			
		], self)
	elif not KnowledgeManager.secretly_knows("Show_Off"):
		SequenceMachine.run_sequence([
			"dialog:1460",
			"action:secretly_learn:Show_Off",
		], self)
	
	
	else:
		SequenceMachine.run_sequence([
			"dialog:1072",
		], self)
