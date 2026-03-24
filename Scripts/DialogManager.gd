#Dialog Manager

extends Node

var dialog_active = false
var dialog_table = {}
var current_language = "en"
var current_id = ""
var dialog_finished_callback: Callable = Callable()
var dialog_vars = {}

func _ready():
	load_csv("res://dialog/dialog.csv")
	print("Loaded dialog keys: ", dialog_table["en"].keys())

func reset_dialog_state():
	dialog_active = false
	current_id = ""
	dialog_finished_callback = Callable()
	TextBox.hide_dialog()

func load_csv(path: String):
	dialog_table.clear()

	var file = FileAccess.open(path, FileAccess.READ)
	var lines = file.get_as_text().split("\n")

	var header = []
	var first = true

	var condition_col = -1
	var speaker_col = -1
	var portrait_col = -1
	var text_col = -1
	var choice_col = -1
	var next_col = -1
	var action_col = -1

	for line in lines:
		line = line.strip_edges()
		if line == "":
			continue

		var cells = parse_csv_line(line)

		if first:
			header = cells
			first = false

			condition_col = header.find("condition")
			speaker_col = header.find("speaker")
			portrait_col = header.find("portrait")
			text_col = header.find("en")
			choice_col = header.find("choice")
			next_col = header.find("next")
			action_col = header.find("action")
			continue

		var key = cells[0]

		var raw_text = ""
		if text_col != -1 and text_col < cells.size():
			raw_text = cells[text_col].strip_edges()
			if raw_text.begins_with('"') and raw_text.ends_with('"'):
				raw_text = raw_text.substr(1, raw_text.length() - 2)
				raw_text = raw_text.replace('""', '"')
			raw_text = raw_text.replace("\\n", "\n")


		var parsed_choices = ""
		var parsed_next = ""
		var parsed_action = ""

		var parsed_condition = ""
		if condition_col != -1 and condition_col < cells.size():
			parsed_condition = cells[condition_col].strip_edges()

		var speaker = ""
		if speaker_col != -1 and speaker_col < cells.size():
			speaker = cells[speaker_col].strip_edges()

		var portrait = ""
		if portrait_col != -1 and portrait_col < cells.size():
			portrait = cells[portrait_col].strip_edges()

		if choice_col != -1 and choice_col < cells.size():
			parsed_choices = cells[choice_col].strip_edges()

		if next_col != -1 and next_col < cells.size():
			parsed_next = cells[next_col].strip_edges()

		if action_col != -1 and action_col < cells.size():
			parsed_action = cells[action_col].strip_edges()

		if not dialog_table.has("en"):
			dialog_table["en"] = {}

		dialog_table["en"][key] = {
			"condition": parsed_condition,
			"speaker": speaker,
			"portrait": portrait,
			"text": raw_text,
			"choice": parsed_choices,
			"next": parsed_next,
			"action": parsed_action
		}

func condition_is_true(condition: String) -> bool:
	if condition == "" or condition == null:
		return true

	var parts = condition.split("&")
	for part in parts:
		part = part.strip_edges()

		if part.begins_with("knows:"):
			var key = part.substr(6)
			if not KnowledgeManager.secretly_knows(key):
				return false

		elif part.begins_with("not_knows:"):
			var key = part.substr(10)
			if KnowledgeManager.secretly_knows(key):
				return false

		elif part.begins_with("has_type:"):
			var t = part.substr(9)
			if not ItemManager.inventory_has_type(t):
				return false

		elif part.begins_with("not_has_type:"):
			var t = part.substr(13)
			if ItemManager.inventory_has_type(t):
				return false

		elif part.begins_with("has_money:"):
			var amount = float(part.substr("has_money:".length()))
			if ItemManager.cash < amount:
				return false

		elif part.begins_with("not_has_money:"):
			var amount = float(part.substr("not_has_money:".length()))
			if ItemManager.cash >= amount:
				return false

		elif part.begins_with("can_afford:"):
			var id = part.substr("can_afford:".length())
			if ItemDatabase.items.has(id):
				var price = float(ItemDatabase.items[id].get("value", 0.0))
				if ItemManager.cash < price:
					return false

		elif part.begins_with("cannot_afford:"):
			var id = part.substr("cannot_afford:".length())
			if ItemDatabase.items.has(id):
				var price = float(ItemDatabase.items[id].get("value", 0.0))
				if ItemManager.cash >= price:
					return false


	return true

func format_text(raw_text: String, values: Dictionary = {}) -> String:
	if values.is_empty():
		return raw_text
	return raw_text.format(values)

func parse_csv_line(line: String) -> Array:
	var cells = []
	var current = ""
	var in_quotes = false

	for i in line.length():
		var char = line[i]
		if char == "," and not in_quotes:
			cells.append(current)
			current = ""
		elif char == '"':
			if in_quotes and i + 1 < line.length() and line[i + 1] == '"':
				current += '"'
				i += 1
			else:
				in_quotes = !in_quotes
		else:
			current += char
	cells.append(current)
	return cells

func get_line(id: String, substitutions := {}) -> String:
	var line = dialog_table.get(current_language, {}).get(id, "")
	for k in substitutions:
		line = line.replace("{" + k + "}", str(substitutions[k]))
	return line

func start_dialog(id: String, finished_callback: Callable):
	dialog_finished_callback = finished_callback
	dialog_active = true
	current_id = id
	TextBox.set_skin(false)
	PortraitManager.set_mode("dialog")
	PortraitManager.clear_portrait()
	show_current_line()

func show_current_line():
	if not dialog_active:
		return

	var entry = dialog_table[current_language].get(current_id, null)
	if entry == null:
		push_error("Dialog ID not found: " + current_id)
		end_dialog()
		return

	if not condition_is_true(entry["condition"]):
		advance_dialog()
		return

	var raw = entry["text"]
	var speaker = entry["speaker"]
	var portrait = entry["portrait"]
	var text = entry["text"]

	text = substitutions(text)

	PortraitManager.apply_visuals(
		entry.get("portrait", ""),
		entry.get("perception", "")
	)

	TextBox.show_dialog_text(text, speaker)
	TextBox.waiting_for_input = true

	if entry["choice"] != "":
		var labels = entry["choice"].split("|")
		var next_ids = entry["next"].split("|")

		if next_ids.size() != labels.size():
			end_dialog()
			return

		var choice_map = {}
		for i in range(labels.size()):
			var label = substitutions(labels[i])
			var next_id = next_ids[i]
			choice_map[label] = func():
				current_id = next_id
				show_current_line()

		TextBox.show_choice_buttons(choice_map)
		return

	run_action(entry["action"])

	if entry["next"] == "END":
		return

func start_shop_dialog(id: String, finished_callback: Callable):
	dialog_finished_callback = finished_callback
	dialog_active = true
	current_id = id
	TextBox.set_skin(true)
	PortraitManager.set_mode("shop")
	show_current_line()

func run_action(action: String):
	if action == "" or action == null:
		return

	var parts = action.split(":")
	var func_name = parts[0]
	var arg = null
	if parts.size() > 1:
		arg = parts[1]

	# Built-in mappings (mirror SequenceMachine)
	match func_name:
		"learn":
			if arg: KnowledgeManager.learn(arg)
			return
		"secretly_learn":
			if arg: KnowledgeManager.secretly_learn(arg)
			return
		"forget":
			if arg: KnowledgeManager.forget(arg)
			return
		"secretly_forget":
			if arg: KnowledgeManager.secretly_forget(arg)
			return
		"add_number":
			if arg: NumberManager.add_number(arg)
			return
		"give_item":
			if arg: ItemManager.add_item(arg)
			return
		"take_money":
			if arg: ItemManager.spend_currency(float(arg))
			return
		"buy_item":
			if arg:
				var id = arg
				if ItemDatabase.items.has(id):
					var price = float(ItemDatabase.items[id].get("value", 0.0))
					if ItemManager.cash >= price:
						ItemManager.spend_currency(price)
						ItemManager.add_item(id)
					else:
						print("Not enough money to buy:", id)
			return


		_:

			if has_method(func_name):
				if arg:
					call(func_name, arg)
				else:
					call(func_name)
				return

			push_error("DialogManager: Unknown action function: " + func_name)

#Substitutions

func substitutions(text: String) -> String:
	var subs = {}
	subs["requested_attribute"] = GameState.get_attribute_for_current_day()

	for k in subs:
		text = text.replace("{" + k + "}", str(subs[k]))


	if DialogManager.dialog_vars:
		for k in DialogManager.dialog_vars.keys():
			text = text.replace("{" + k + "}", str(DialogManager.dialog_vars[k]))

	#How to use {price:item_id}
	var regex = RegEx.new()
	regex.compile("\\{price:([a-zA-Z0-9_]+)\\}")

	var result = regex.search_all(text)
	if result:
		for match in result:
			var item_id = match.get_string(1)
			if ItemDatabase.items.has(item_id):
				var price = float(ItemDatabase.items[item_id].get("value", 0.00))
				var formatted = ItemManager.format_money(price)
				text = text.replace("{price:" + item_id + "}", formatted)

	return text


func set_dialog_var(key: String, value: String):
	dialog_vars[key] = value


func advance_dialog():
	if not dialog_active:
		return

	var lang_table = dialog_table.get(current_language, null)
	if lang_table == null:
		end_dialog()
		return

	var next_id = lang_table[current_id]["next"].strip_edges()

	if next_id == "" or next_id == "END":
		end_dialog()
		return

	# Walk forward until we find a valid line
	while next_id != "" and next_id != "END":
		var entry = lang_table.get(next_id, null)
		if entry == null:
			end_dialog()
			return

		if condition_is_true(entry["condition"]):
			current_id = next_id
			show_current_line()
			return

		next_id = entry["next"].strip_edges()
	end_dialog()

func end_dialog():
	dialog_active = false
	TextBox.hide_dialog()
	PortraitManager.clear_portrait()

	if dialog_finished_callback.is_valid():
		dialog_finished_callback.call()
		dialog_finished_callback = Callable()

#Actions

func save_game():
	print("Game saved!")
