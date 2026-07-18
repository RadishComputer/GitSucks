#Dave

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
	default_dialog()


func end_dialog():
	SequenceMachine.run_sequence([
		"dialog:1854",  
	], self)

func radio_dialog():
		SequenceMachine.run_sequence([
			"action:learn:Radio_Returned",
			"action:remove_item:" + "daves_radio",
			"dialog:1855",
			"note:[center]Yes", 
			"dialog:1901",
			"await:2.0",
			"dialog:1950",
			"action:go_back",
		], self)

func default_dialog():
	SequenceMachine.run_sequence([
			"dialog:1177",  
			"action:go_back",
		], self)

func on_item_used(target: Node, item_id: String):
	if target != self:
		return
	self.visible = false
	var item = ItemDatabase.items.get(item_id, {})
	DialogManager.dialog_vars["item"] = item.get("name", "that")
	if item_id != "daves_radio":
		SequenceMachine.run_sequence([
			"dialog:1853",
			"action:go_back",
		], self)
		return
	else:
		SequenceMachine.run_sequence([
			"action:learn:Radio_Returned",
			"action:remove_item:" + item_id,
			"dialog:1857",
			"note:Yes",
			"dialog:1901",
			"await:2.0",
			"dialog:1950",
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
