#Sequence Machine

extends Node2D

signal sequence_finished(target)

var sequence: Array = []
var index = 0
var running = false
var action_target: Object = null

func run_sequence(steps: Array, target: Object = null):
	if running:
		print("SequenceMachine: already running")
		return

	sequence = steps
	action_target = target
	index = 0
	running = true
	run_next_step()


func run_next_step():
	if index > 0 and sequence[index - 1].begins_with("dialog:"):
		GameGlue.PortraitManager.apply_visuals("none", "none")
	if index >= sequence.size():
		running = false
		print("SequenceMachine: no longer running")
		emit_signal("sequence_finished", action_target)
		return

	var step = sequence[index]
	index += 1

	if step.begins_with("dialog:"):
		var id = step.substr(7)
		GameGlue.DialogManager.start_dialog(id, Callable(self, "run_next_step"))
		return

	if step.begins_with("note:"):
		var parts = step.split(":")
		var text = ""
		var sound_key = "default"

		if parts.size() > 1:
			text = parts[1]
		if parts.size() > 2:
			sound_key = parts[2]

		print("→ SequenceMachine is showing note:", text, "with sound:", sound_key)
		GameGlue.TextBox.show_note(text, Callable(self, "run_next_step"), sound_key)
		return


	if step.begins_with("shopdialog:"):
		var id = step.substr(11)
		GameGlue.DialogManager.start_shop_dialog(id, Callable(self, "run_next_step"))
		return

	if step.begins_with("action:"):
		var parts = step.split(":")
		var action_name = parts[1]
		var arg = ""

		if parts.size() > 2:
			for i in range(2, parts.size()):
				if i > 2:
					arg += ":"
				arg += parts[i]

		match action_name:
			"learn":
				GameGlue.KnowledgeManager.learn(arg)
			"secretly_learn":
				GameGlue.KnowledgeManager.secretly_learn(arg)
			"forget":
				GameGlue.KnowledgeManager.forget(arg)
			"secretly_forget":
				GameGlue.KnowledgeManager.secretly_forget(arg)
			"add_number":
				GameGlue.NumberManager.add_number(arg)
			"remove_item":
				GameGlue.ItemManager.remove_item(arg)
				GameGlue.ItemManager.update_cursor_icon()
			"advance_scene":
				GameGlue.ClockManager.next_scene_path = arg
				GameGlue.ClockManager.switch_scene(true)
			"switch_scene":
				GameGlue.ClockManager.next_scene_path = arg
				GameGlue.ClockManager.switch_scene(false)
			"fade_to_black":
				GameGlue.fade_to_black()
			"snap_back":
				GameGlue.snap_back()
			"quit_game":
				if action_target and action_target.has_method("quit_game"):
					action_target.quit_game()
				else:
					get_tree().quit()
			_:
				if action_target != null and action_target.has_method(action_name):
					if arg != "":
						action_target.call(action_name, arg)
					else:
						action_target.call(action_name)
				elif has_method(action_name):
					if arg != "":
						call(action_name, arg)
					else:
						call(action_name)
				else:
					print("SequenceMachine: Unknown action:", action_name)

		run_next_step()
		return

	if step.begins_with("await:"):
		var value = step.substr("await:".length())
		await handle_await(value)
		run_next_step()
		return

func handle_await(value: String):
	var seconds = float(value)
	await get_tree().create_timer(seconds).timeout
