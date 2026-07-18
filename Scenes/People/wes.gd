#Wes

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
	if KnowledgeManager.knows("Met_Wes"):
		wes_dialog()
		return
	first_dialog()

func end_dialog():
	SequenceMachine.run_sequence([
		"dialog:1791",
	], self)

func radio_dialog():
		SequenceMachine.run_sequence([
		"dialog:1792",
		"action:go_back",
	], self)

func rodney_dialog():
	SequenceMachine.run_sequence([
		"dialog:1789",
		"action:go_back",
	], self)

func dave_dialog():
	SequenceMachine.run_sequence([
		"dialog:1786",
		"action:go_back",
	], self)

func wes_dialog():
		SequenceMachine.run_sequence([
			"dialog:1096",
			"action:go_back",
		], self)

func first_dialog():
		SequenceMachine.run_sequence([
			"action:learn:Met_Wes",
 			"dialog:1091",
			"action:go_back",
			"note:[center]Met Wes[/center]",
		], self)

func on_item_used(target: Node, item_id: String):
	if target != self:
		return
	var item = ItemDatabase.items.get(item_id, {})
	DialogManager.dialog_vars["item"] = item.get("name", "that")
	SequenceMachine.run_sequence([
		"dialog:1095",
		"action:go_back",
	], self)

func _gui_input(event):
	if InputManager.click_release(event):
		if ItemManager.slots[ItemManager.cursor_slot] != "":
			ItemManager.use_item(self)
			
			Menu.selected_item = ""
			Menu.drag_origin_index = -1
			ItemManager.update_cursor_icon()
			get_viewport().set_input_as_handled()
			return
