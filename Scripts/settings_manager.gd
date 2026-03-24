#Settings Manager

extends Node2D

const SETTINGS_PATH = "user://settings.cfg"

const PRESETS = [
	{"name": "854×480",   "width": 854,  "height": 480},
	{"name": "1920×1080", "width": 1920, "height": 1080},
]



# Current settings
var preset_index: int = 1
var fullscreen: bool = false
var use_custom_resolution: bool = false
var custom_width: int = 0
var custom_height: int = 0


# UI / Accessibility
enum ItemMode { SWITCH, HOLD }
enum MenuStyle { PLAIN, PURE }

var item_mode: ItemMode = ItemMode.SWITCH
var menu_style: MenuStyle = MenuStyle.PLAIN
var high_contrast: bool = false
var grayscale: bool = false
var bounce_mode: bool = true
var text_size: = "M"

func _ready() -> void:
	load_settings()
	apply_display_settings()
	apply_text_theme()

func save_settings() -> void:
	var cfg = ConfigFile.new()

	# Display
	cfg.set_value("display", "preset_index", preset_index)
	cfg.set_value("display", "fullscreen", fullscreen)
	cfg.set_value("display", "use_custom", use_custom_resolution)
	cfg.set_value("display", "custom_w", custom_width)
	cfg.set_value("display", "custom_h", custom_height)

	# UI / Accessibility
	cfg.set_value("ui", "item_mode", int(item_mode))
	cfg.set_value("ui", "menu_style", int(menu_style))
	cfg.set_value("ui", "high_contrast", high_contrast)
	cfg.set_value("ui", "grayscale", grayscale)
	cfg.set_value("ui", "bounce_mode", bounce_mode)
	cfg.set_value("ui", "text_size", text_size)

	var err = cfg.save(SETTINGS_PATH)
	if err != OK:
		push_warning("Failed to save settings: %s" % err)


func load_settings() -> void:
	var cfg = ConfigFile.new()
	if cfg.load(SETTINGS_PATH) != OK:
		return  # use defaults

	# Display
	preset_index          = cfg.get_value("display", "preset_index", preset_index)
	fullscreen            = cfg.get_value("display", "fullscreen", fullscreen)
	use_custom_resolution = cfg.get_value("display", "use_custom", use_custom_resolution)
	custom_width          = cfg.get_value("display", "custom_w", custom_width)
	custom_height         = cfg.get_value("display", "custom_h", custom_height)

	# UI
	var raw_item_mode = cfg.get_value("ui", "item_mode", -1)
	if raw_item_mode is int and raw_item_mode >= 0 and raw_item_mode < ItemMode.size():
		item_mode = ItemMode.values()[raw_item_mode]

	var raw_menu_style = cfg.get_value("ui", "menu_style", -1)
	if raw_menu_style is int and raw_menu_style >= 0 and raw_menu_style < MenuStyle.size():
		menu_style = MenuStyle.values()[raw_menu_style]

	high_contrast = bool( cfg.get_value("ui", "high_contrast", high_contrast))
	grayscale     = bool( cfg.get_value("ui", "grayscale", grayscale))
	bounce_mode   = bool(cfg.get_value("ui", "bounce_mode", bounce_mode))
	text_size     = cfg.get_value("ui", "text_size", text_size)

func set_preset(index: int, go_fullscreen = false) -> void:
	if index < 0 or index >= PRESETS.size():
		return

	preset_index = index
	fullscreen = go_fullscreen
	use_custom_resolution = false

	apply_display_settings()
	save_settings()


func use_custom_size(w: int, h: int) -> void:
	if w < 320 or h < 180:
		return

	custom_width = w
	custom_height = h
	use_custom_resolution = true
	fullscreen = false

	apply_display_settings()
	save_settings()


func capture_current_window_size() -> void:
	var win = get_window()
	if not win:
		return

	var s = win.size
	use_custom_size(s.x, s.y)


func toggle_fullscreen() -> void:
	fullscreen = !fullscreen
	apply_display_settings()
	save_settings()


func apply_display_settings() -> void:
	var win = get_window()
	if not win:
		return

	var target_size := Vector2i.ZERO

	if use_custom_resolution and custom_width > 0 and custom_height > 0:
		target_size = Vector2i(custom_width, custom_height)
	else:
		var idx = clamp(preset_index, 0, PRESETS.size() - 1)
		var p = PRESETS[idx]
		target_size = Vector2i(p.width, p.height)

	win.size = target_size

	win.mode = Window.MODE_FULLSCREEN if fullscreen else Window.MODE_WINDOWED


func get_current_resolution_text() -> String:
	if use_custom_resolution:
		return "%d × %d (custom)" % [custom_width, custom_height]

	var idx = clamp(preset_index, 0, PRESETS.size() - 1)
	var p = PRESETS[idx]
	return "%d × %d" % [p.width, p.height]

func get_settings_debug_string() -> String:
	return """
Resolution: %s
Fullscreen: %s
Item mode: %s
Menu style: %s
High contrast: %s
Grayscale: %s
	""" % [
		get_current_resolution_text(),
		fullscreen,
		ItemMode.keys()[item_mode],
		MenuStyle.keys()[menu_style],
		high_contrast,
		grayscale
	]

func apply_text_theme():
	print("UI nodes:", get_tree().get_nodes_in_group("UI"))
	var theme_path = ""
	
	match text_size:
		"S":
			theme_path = "res://Elements/theme_s.tres"
		"M":
			theme_path = "res://Elements/theme_m.tres"
		"L":
			theme_path = "res://Elements/theme_l.tres"

	var theme_res = load(theme_path)
	if not theme_res:
		return

	for ui_root in get_tree().get_nodes_in_group("UI"):
		ui_root.theme = theme_res
