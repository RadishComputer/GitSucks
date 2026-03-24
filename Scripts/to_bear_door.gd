extends Area2D

func _ready():
	ItemManager.connect("item_used_on_target", Callable(self, "on_item_used"))
	add_to_group("targets")

func _input_event(viewport, event, shape_idx):
	if InputManager.click_release(event):

		if SettingsManager.item_mode == SettingsManager.ItemMode.HOLD and Menu.dragging:
			Menu.end_drag(self)
			return

		if KnowledgeManager.knows("Bear_Room_Door_Opened"):
			if ItemManager.slots[ItemManager.cursor_slot] == "":
				call_deferred("on_exit")
			return

		if ItemManager.slots[ItemManager.cursor_slot] != "":
			ItemManager.use_item(self)
			Menu.selected_item = ""
			Menu.drag_origin_index = -1
			ItemManager.update_cursor_icon()
			return

		if not KnowledgeManager.secretly_knows("Door_Tried"):
			SequenceMachine.run_sequence([
				"dialog:1026",
				"action:secretly_learn:Door_Tried"
			], self)
		else:
			SequenceMachine.run_sequence([
				"dialog:1027"
			], self)


func on_item_used(target: Node, item_id: String):
	if target == self:
		if item_id == "pocket_knife":
			SequenceMachine.run_sequence([
				"note:[center]Bear Room Door Opened.[/center]",
				"action:learn:Bear_Room_Door_Opened"
			], self)
		else:
			SequenceMachine.run_sequence([
				"note:[center]That item doesn't work here.[/center]"
			], self)

func on_exit():
	ClockManager.next_scene_path = "res://Scenes/Upstairs.tscn"
	ClockManager.switch_scene(true)
