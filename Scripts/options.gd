extends Panel

func _ready():
	GameGlue.SettingsManager.load_settings()
	GameGlue.SettingsManager.apply_display_settings()
	
	$VBox/HBox1/Switch.pressed.connect(on_item_mode_pressed.bind(GameGlue.SettingsManager.ItemMode.SWITCH))
	$VBox/HBox1/Hold.pressed.connect(on_item_mode_pressed.bind(GameGlue.SettingsManager.ItemMode.HOLD))
	update_item_mode_visual()

	$VBox/HBox2/Plain.pressed.connect(on_menu_style_pressed.bind(GameGlue.SettingsManager.MenuStyle.PLAIN))
	$VBox/HBox2/Pure.pressed.connect(on_menu_style_pressed.bind(GameGlue.SettingsManager.MenuStyle.PURE))
	update_menu_style_visual()

	$VBox/HBox3/Off.pressed.connect(on_high_contrast_pressed.bind(false))
	$VBox/HBox3/On.pressed.connect(on_high_contrast_pressed.bind(true))
	update_high_contrast_visual()

	$VBox/HBox4/Off.pressed.connect(on_grayscale_pressed.bind(false))
	$VBox/HBox4/On.pressed.connect(on_grayscale_pressed.bind(true))
	update_grayscale_visual()

	$VBox/HBox5/Off.pressed.connect(on_bounce_pressed.bind(false))
	$VBox/HBox5/On.pressed.connect(on_bounce_pressed.bind(true))
	update_bounce_visual()

	$VBox/HBox6/S.pressed.connect(on_size_pressed.bind("S"))
	$VBox/HBox6/M.pressed.connect(on_size_pressed.bind("M"))
	$VBox/HBox6/L.pressed.connect(on_size_pressed.bind("L"))
	update_size_visual()

	$VBox/HBoxD/Display0.pressed.connect(on_display_pressed.bind(0))
	$VBox/HBoxD/Display1.pressed.connect(on_display_pressed.bind(1))
	$VBox/HBoxD/Full.pressed.connect(on_full_pressed)
	update_resolution_visual()

#Item Mode

func on_item_mode_pressed(mode: int):
	GameGlue.SettingsManager.item_mode = mode
	GameGlue.SettingsManager.save_settings()
	update_item_mode_visual()
	
func update_item_mode_visual():
	var is_switch = GameGlue.SettingsManager.item_mode == GameGlue.SettingsManager.ItemMode.SWITCH
	$VBox/HBox1/Switch.button_pressed = is_switch
	$VBox/HBox1/Hold.button_pressed = not is_switch

#Menu Style

func on_menu_style_pressed(mode: int):
	GameGlue.SettingsManager.menu_style = mode
	GameGlue.SettingsManager.save_settings()
	update_menu_style_visual()
	update_high_contrast_visual()
	update_grayscale_visual()

func update_menu_style_visual():
	var is_plain = GameGlue.SettingsManager.menu_style == GameGlue.SettingsManager.MenuStyle.PLAIN
	$VBox/HBox2/Plain.button_pressed = is_plain
	$VBox/HBox2/Pure.button_pressed = not is_plain
	$"../Device".visible = is_plain

#High Contrast

func on_high_contrast_pressed(value: bool):
	GameGlue.SettingsManager.high_contrast = value
	GameGlue.SettingsManager.save_settings()
	update_high_contrast_visual()

func update_high_contrast_visual():
	var enabled = GameGlue.SettingsManager.high_contrast
	$VBox/HBox3/Off.button_pressed = not enabled
	$VBox/HBox3/On.button_pressed = enabled
	$"../../CanvasLayer/ColorRect".material.set_shader_parameter("high_contrast_enabled", enabled)

#Grayscale

func on_grayscale_pressed(value: bool):
	GameGlue.SettingsManager.grayscale = value
	GameGlue.SettingsManager.save_settings()
	update_grayscale_visual()

func update_grayscale_visual():
	var enabled = GameGlue.SettingsManager.grayscale
	$VBox/HBox4/Off.button_pressed = not enabled
	$VBox/HBox4/On.button_pressed = enabled
	$"../../CanvasLayer/ColorRect".material.set_shader_parameter("grayscale_enabled", enabled)

#Bounce

func on_bounce_pressed(value: bool):
	GameGlue.SettingsManager.bounce_mode = value
	GameGlue.SettingsManager.save_settings()
	update_bounce_visual()

func update_bounce_visual():
	var enabled = GameGlue.SettingsManager.bounce_mode
	$VBox/HBox5/Off.button_pressed = not enabled
	$VBox/HBox5/On.button_pressed = enabled

#Font Size

func on_size_pressed(size: String):
	GameGlue.SettingsManager.text_size = size
	GameGlue.SettingsManager.save_settings()
	update_size_visual()
	GameGlue.SettingsManager.apply_text_theme()

func update_size_visual():
	var size = GameGlue.SettingsManager.text_size
	$VBox/HBox6/S.button_pressed = size == "S"
	$VBox/HBox6/M.button_pressed = size == "M"
	$VBox/HBox6/L.button_pressed = size == "L"

#Display

func on_display_pressed(index: int):
	GameGlue.SettingsManager.set_preset(index, false)
	update_resolution_visual()


func on_full_pressed():
	GameGlue.SettingsManager.toggle_fullscreen()
	update_resolution_visual()

func update_resolution_visual():
	for i in range(GameGlue.SettingsManager.PRESETS.size()):
		var path = "VBox/HBox6/Display%d" % i
		if has_node(path):
			get_node(path).button_pressed = false
	
	if not GameGlue.SettingsManager.use_custom_resolution:
		var idx = clamp(GameGlue.SettingsManager.preset_index, 0, GameGlue.SettingsManager.PRESETS.size() - 1)
		var path = "VBox/HBox6/Display%d" % idx
		if has_node(path):
			get_node(path).button_pressed = true
	
	# Fullscreen button visual (On/Off style)
	if has_node("VBox/HBox6/Full"):
		$VBox/HBox6/Full.button_pressed = GameGlue.SettingsManager.fullscreen
