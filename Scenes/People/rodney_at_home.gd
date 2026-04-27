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
	self.visible = false
	if not KnowledgeManager.knows("Got_Daves_Radio"):
		SequenceMachine.run_sequence([
			"dialog:1345", #This is the only change in the dialog tree in the evening
			"action:go_back",
		], self)
	elif not KnowledgeManager.secretly_knows("Show_Off"):
		SequenceMachine.run_sequence([
			"dialog:1777",
			"action:secretly_learn:Show_Off",
		], self)
	else:
		SequenceMachine.run_sequence([
			"dialog:1072",
		], self)

func on_item_used(target: Node, item_id: String):
	if target != self:
		return

	var item = ItemDatabase.items.get(item_id, {})
	var name = item.get("name", "")
	DialogManager.dialog_vars["item"] = name

	if name == "Pocket Knife":
		SequenceMachine.run_sequence([
			"dialog:1",
			"action:remove_item:pocket_knife",
			"action:secretly_learn:Rodney_the_Knife",
		], self)
		return

	if name == "Dave's Radio":
		SequenceMachine.run_sequence([
			"dialog:2",
		], self)
		return

	SequenceMachine.run_sequence([
		"dialog:3",
		"action:go_back",
	], self)
