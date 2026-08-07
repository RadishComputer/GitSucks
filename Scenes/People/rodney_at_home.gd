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

func clicked(viewport, event, shape_idx):
	self.visible = false
	if not KnowledgeManager.knows("Got_Daves_Radio"):
		SequenceMachine.run_sequence([
			"dialog:1490",#What do you want now?
			"action:go_back",
		], self)
	else:
		SequenceMachine.run_sequence([
			"dialog:1460",
			"action:secretly_learn:Show_Off",
		], self)

func on_item_used(target: Node, item_id: String):
	if target != self:
		return

	var item = ItemDatabase.items.get(item_id, {})
	var name = item.get("name", "")
	DialogManager.dialog_vars["item"] = name

	if name == "Pocket Knife":
		SequenceMachine.run_sequence([
			"dialog:1496",
			"action:remove_item:pocket_knife",
			"action:get_radio",
			"action:secretly_learn:Rodney_the_Knife",
			"action:learn:Dave's_Radio_Collected",
			"note:[center]Got Dave's Radio",
		], self)
		return

	if name == "Dave's Radio":
		SequenceMachine.run_sequence([
			"dialog:1498",
		], self)
		return

	SequenceMachine.run_sequence([
		"dialog:1494",
		"action:go_back",
	], self)

func get_radio():
	ItemManager.add_item("daves_radio")
