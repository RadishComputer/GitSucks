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
	GameGlue.ItemManager.connect("item_used_on_target", Callable(self, "on_item_used"))
	add_to_group("targets")
	print("Door groups:", get_groups())

func _gui_input(event):
	if GameGlue.InputManager.click_release(event):
		if GameGlue.SettingsManager.item_mode == GameGlue.SettingsManager.ItemMode.HOLD and GameGlue.Menu.dragging:
			GameGlue.Menu.end_drag(self)
			return

		if GameGlue.SettingsManager.item_mode == GameGlue.SettingsManager.ItemMode.SWITCH \
		and GameGlue.Menu.selected_item != "":
			return

		if GameGlue.KnowledgeManager.knows("Bear_Room_Door_Opened"):
			call_deferred("on_exit")
			return

		if not GameGlue.KnowledgeManager.secretly_knows("Door_Tried"):
			GameGlue.SequenceMachine.run_sequence([
				"dialog:1026",
				"action:secretly_learn:Door_Tried"
			], self)
		else:
			GameGlue.SequenceMachine.run_sequence([
				"dialog:1027"
			], self)

func on_item_used(target: Node, item_id: String):
	if target == self:
		if item_id == "pocket_knife":
			GameGlue.SequenceMachine.run_sequence([
				"note:[center]Bear Room Door Opened.[/center]",
				"action:learn:Bear_Room_Door_Opened"
			], self)
		else:
			GameGlue.SequenceMachine.run_sequence([
				"note:[center]That item doesn't work here.[/center]"
			], self)

func on_exit():
	GameGlue.ClockManager.next_scene_path = "res://Scenes/Upstairs.tscn"
	GameGlue.ClockManager.switch_scene(true)
