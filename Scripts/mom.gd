#Mom

extends TextureButton

var requested_attribute = ""
var requested = false
var received = false

func _ready():
	add_to_group("targets")
	ItemManager.connect("item_used_on_target", Callable(self, "on_item_used"))
	received = KnowledgeManager.secretly_knows("Food_Received")
	connect("pressed", Callable(self, "on_item_clicked"))


func go_back():
	self.visible = true
	Bouncer.bounce(self)

func on_item_used(target: Node, item_id: String):
	if target != self:
		return

	requested_attribute = GameState.get_attribute_for_current_day()

# Normalize item attributes
	var attributes = []
	var item = ItemDatabase.items.get(item_id, {})
	var cost = float(item.get("value", 0.0))
	for a in item.get("attribute", []):
		attributes.append(a.to_lower())

# Normalize requested attribute for comparison
	var correct = requested_attribute.to_lower() in attributes

# Set pretty display versions
	DialogManager.dialog_vars["requested_attribute"] = requested_attribute.capitalize()
	DialogManager.dialog_vars["item"] = item.get("name", item_id)

	if item.get("type") != "food":
		SequenceMachine.run_sequence([
			"dialog:1012",
			"action:go_back",
		], self)
		return

	#If you buy food for Mom before she requests food you should get something (who are you and what have you done with my daughter)
	if not KnowledgeManager.secretly_knows("Requested_Food"):
		SequenceMachine.run_sequence([
			"dialog:1015",
			"action:go_back",
		], self)
		return

	if KnowledgeManager.secretly_knows("Food_Received"):
		SequenceMachine.run_sequence([
			"dialog:1016",
			"action:go_back",
		], self)
		return

	if correct:
		SequenceMachine.run_sequence([
			"action:secretly_learn:Food_Received",
			"dialog:1009",
			"action:go_back",
		], self)
		return

	var wrong_attributes = []
	for a in attributes:
		if a != requested_attribute.to_lower():
			wrong_attributes.append(a)

	var actual = wrong_attributes[randi() % wrong_attributes.size()]
	DialogManager.dialog_vars["actual"] = actual.capitalize()
		
	ItemManager.spend_currency(cost)
	ItemManager.emit_signal("inventory_updated")

	var amount = "%.2f" % cost

	SequenceMachine.run_sequence([
		"action:secretly_learn:Food_Received",
		"dialog:1010",
		"action:go_back",
		"note:[center]Mom took $" + amount + "[/center]",
	], self)

func on_item_clicked():
	self.visible = false
	if not KnowledgeManager.secretly_knows("Requested_Food"):
		requested_attribute = GameState.get_attribute_for_current_day()

		SequenceMachine.run_sequence([
			"action:learn:Mom_Requested_" + requested_attribute + "_Food",
			"action:secretly_learn:Requested_Food",
			"action:mom_gives_money",
			"dialog:1001",
			"action:go_back",
			"note:[center]Mom Requested " + requested_attribute + " Food[/center]",
		], self)
		return

	elif not KnowledgeManager.secretly_knows("Food_Received"):
		SequenceMachine.run_sequence([
			"dialog:1008",
			"action:go_back",
		], self)
		return
	else:
		SequenceMachine.run_sequence([
			"dialog:1011",
			"action:go_back",
		], self)

func mom_gives_money():
	ItemManager.cash += 20
	ItemManager.emit_signal("inventory_updated")

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
