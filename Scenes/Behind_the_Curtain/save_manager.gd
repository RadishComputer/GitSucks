extends Node

const SAVE_PATH = "user://savegame.json"

var pending_save_note = false

func save_game():
	GameGlue.GameState.last_scene = GameGlue.ClockManager.phone_return_path
	saving()
	pending_save_note = true

func saving():
	var data = {
		"knowledge": GameGlue.KnowledgeManager.export_state(),
		"items": GameGlue.ItemManager.export_state(),
		"cash": GameGlue.ItemManager.cash,
		"clock": GameGlue.ClockManager.export_state(),
		"numbers": GameGlue.NumberManager.export_state(),
		"game_state": GameGlue.GameState.export_state()
	}

	var json = JSON.stringify(data, "\t")
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	file.store_string(json)
	file.close()

func load_game():
	if not FileAccess.file_exists(SAVE_PATH):
		print("No save file found.")
		return false

	var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
	var text = file.get_as_text()
	file.close()

	var result = JSON.parse_string(text)
	if typeof(result) != TYPE_DICTIONARY:
		print("Save file corrupted.")
		return false

	var data = result

	GameGlue.KnowledgeManager.import_state(data.get("knowledge", {}))
	GameGlue.ItemManager.import_state(data.get("items", {}))
	GameGlue.ItemManager.cash = data.get("cash", 0)
	GameGlue.ClockManager.import_state(data.get("clock", {}))
	GameGlue.NumberManager.import_state(data.get("numbers", {}))
	GameGlue.GameState.import_state(data.get("game_state", {}))

	var scene_path = GameGlue.GameState.last_scene
	if scene_path != "":
		GameGlue.ClockManager.next_scene_path = scene_path
		GameGlue.ClockManager.switch_scene(false)

	print("Game loaded.")
	return true
