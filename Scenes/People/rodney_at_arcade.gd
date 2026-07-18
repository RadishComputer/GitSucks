#Rodney at Arcade

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
	ItemManager.connect("item_used_on_target", Callable(self, "on_item_used"))
	connect("pressed", Callable(self, "clicked"))

func go_back():
	if KnowledgeManager.secretly_knows("Annoy_Rodney") or KnowledgeManager.knows("Dave's_Radio_Collected"):
		return
	self.visible = true
	Bouncer.bounce(self)

func clicked():
	if ItemManager.slots[ItemManager.cursor_slot] != "":
		return

	if ClockManager.rodney_here("arcade_am"):
		rodney_arcade_am()
		return

	if ClockManager.rodney_here("arcade_pm"):
		rodney_arcade_pm()
		return

func rodney_arcade_am():
	self.visible = false
	if not KnowledgeManager.secretly_knows("Arcade_On"):
		SequenceMachine.run_sequence([
			"dialog:1423",
			"action:go_back",
		], self)
		return
	else:
		SequenceMachine.run_sequence([
			"dialog:1428",
			"action:go_back",
		], self)

func rodney_arcade_pm():
	self.visible = false
	if not KnowledgeManager.knows("Met_Rodney"):
		SequenceMachine.run_sequence([
			"action:learn:Met_Rodney",
			"dialog:1470",
			"action:go_back",
            "note:[center]Met Rodney"
		], self)
		return

	else:
		SequenceMachine.run_sequence([
			"dialog:1490",
			"action:go_back",
			"action:secretly_learn:Ready_To_Trade"
		], self)
		return

func on_item_used(target: Node, item_id: String):
	if target != self:
		return

	if not KnowledgeManager.secretly_knows("Ready_To_Trade"):
				SequenceMachine.run_sequence([
					"dialog:1423",
					"action:go_back",
				], self)
				return

	var item = ItemDatabase.items.get(item_id, {})
	var name = item.get("name", "")
	DialogManager.dialog_vars["item"] = name

	if name == "Pocket Knife":
		SequenceMachine.run_sequence([
			"dialog:1496",
			"action:remove_item:pocket_knife",
			"action:secretly_learn:Rodney_the_Knife",
			"action:learn:Dave's_Radio_Collected",
			"note:[center]Got Dave's Radio",
		], self)
		$"../Daves_Radio".visible = false
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

func _gui_input(event):
	if InputManager.click_release(event):
		if SettingsManager.item_mode == SettingsManager.ItemMode.HOLD and Menu.dragging:
			Menu.end_drag(self)
			return

		if ItemManager.slots[ItemManager.cursor_slot] != "":
			ItemManager.use_item(self)
			Menu.selected_item = ""
			Menu.drag_origin_index = -1
			ItemManager.update_cursor_icon()
			return
