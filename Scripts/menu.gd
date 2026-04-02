extends Control

var selected_item: String = "" 
var drag_origin_index: int = -1

var dragging = false
var drag_consumed = false
var menu_visible = false
var mouse_over_background = false
var hover_time = 0

var tab_buttons = {}
var tab_panels = {}

func _ready():
	
	setup_tabs()
	setup_background()
	$Window/InventoryPanel.slot_created.connect(on_slot_created)

func connect_menu():
	GameGlue.SettingsManager.apply_text_theme()

func setup_tabs():
	tab_buttons = {
		"Items":$Window/Items,
		"Diary":$Window/Diary,
		"Phone":$Window/Phone,
		"Cats":$Window/Cats,
		"Tapes":$Window/Tapes,
		"Options":$Window/Options,
	}
	tab_panels = {
		"Items":$Window/InventoryPanel,
		"Diary":$Window/DiaryPanel,
		"Phone":$Window/PhonePanel,
		"Cats":$Window/CatsPanel,
		"Tapes":$Window/TapesPanel,
		"Options":$Window/OptionsPanel
	}
	on_tab_pressed("Items")
	for name in tab_buttons.keys():
		tab_buttons[name].button_up.connect(on_tab_pressed.bind(name))

func setup_background():
	var background = $Background
	background.mouse_entered.connect(func(): mouse_over_background = true)
	background.mouse_exited.connect(func(): mouse_over_background = false)
	background.gui_input.connect(on_background_gui_input)

######

func input(event: InputEvent):
	match GameGlue.TextBox.current_mode:
		GameGlue.TextBox.Text_Mode.CHOICE:
			get_viewport().set_input_as_handled()
			return



func _process(delta):
	update_cursor()
	update_menu_visibility(delta)
	check_drag_state()

func update_cursor():
	if GameGlue.ItemManager.item_cursor and GameGlue.ItemManager.item_cursor.visible:
		GameGlue.ItemManager.item_cursor.global_position = get_viewport().get_mouse_position()
		
func update_menu_visibility(delta):
	if dragging and mouse_over_background:
		if hover_time == 0:
			hover_time = Time.get_ticks_msec()
		elif Time.get_ticks_msec() - hover_time > 500:
			menu_visible = false
			$Window.visible = false
	else:
		hover_time = 0

func on_background_gui_input(event: InputEvent):
	if GameGlue.InputManager.click_release(event):
		menu_visible = !menu_visible
		if menu_visible:
			$Window.visible = true
			get_tree().paused = true
		else:
			$Window.visible = false
			get_tree().paused = false

func _on_click_muncher_gui_input(event):
	if GameGlue.SettingsManager.item_mode == GameGlue.SettingsManager.ItemMode.SWITCH:
		if selected_item != "" and GameGlue.InputManager.click_release(event):

			var hovered = get_viewport().gui_get_hovered_control()
			if hovered and hovered.has_meta("slot_index"):
				return

			if mouse_over_background:
				return

			return_item_to_inventory()

#Inventory

func on_slot_created(index, btn):
	btn.set_meta("slot_index", index)
	btn.connect("gui_input", on_item_gui_input.bind(index, btn))
	btn.connect("pressed", on_item_pressed.bind(index, btn))
	#btn.mouse_filter = Control.MOUSE_FILTER_STOP

func on_item_gui_input(event, slot_index, btn):
	if GameGlue.SettingsManager.item_mode == GameGlue.SettingsManager.ItemMode.HOLD:
		hold_mode_input(event, slot_index, btn)

func on_item_pressed(slot_index, btn):
	if dragging:
		return
	if GameGlue.SettingsManager.item_mode == GameGlue.SettingsManager.ItemMode.SWITCH:
		switch_mode_input(slot_index, btn)

func hold_mode_input(event, slot_index, btn):
	var item_id = GameGlue.ItemManager.slots[slot_index]
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed and item_id != null and not dragging:
			start_drag(slot_index, item_id)

func switch_mode_input(slot_index, btn):
	if GameGlue.ItemManager.slots[GameGlue.ItemManager.cursor_slot] == "":
		var item_id = GameGlue.ItemManager.slots[slot_index]
		if item_id != "":
			selected_item = item_id
			drag_origin_index = slot_index
			GameGlue.ItemManager.pick_up_item(slot_index)
	else:
		GameGlue.ItemManager.drop_item(slot_index)

func return_item_to_inventory():
	if selected_item == "":
		end_selection()
		return

	if drag_origin_index != -1:
		GameGlue.ItemManager.slots[drag_origin_index] = selected_item
		GameGlue.ItemManager.slots[GameGlue.ItemManager.cursor_slot] = GameGlue.ItemManager.empty_slot
	else:
		GameGlue.ItemManager.slots[GameGlue.ItemManager.cursor_slot] = selected_item

	GameGlue.ItemManager.update_cursor_icon()
	GameGlue.ItemManager.emit_signal("inventory_updated")
	end_selection()

#Menu

func on_tab_pressed(tab_name: String):
	for name in tab_buttons.keys():
		tab_buttons[name].set_pressed_no_signal(name == tab_name)
		tab_panels[name].visible = (name == tab_name)

func _unhandled_input(event: InputEvent):
	if event is InputEventMouseButton and event.pressed:
		print("Room root got click at", event.position)
	if dragging and GameGlue.InputManager.drag_release(event):
		print("[Menu] _unhandled_input → drag_release branch")
		handle_drag_release()
	elif GameGlue.InputManager.click_release(event):
		print("[Menu] _unhandled_input → click_release branch")
		handle_click_release()
	elif GameGlue.InputManager.right_click_release(event):
		print("[Menu] _unhandled_input → right_click branch")
		handle_right_click_release()

func handle_release():
	var hovered = get_viewport().gui_get_hovered_control()
	if hovered and hovered.has_meta("slot_index"):
		var target_index = hovered.get_meta("slot_index")
		var target_item = GameGlue.ItemManager.slots[target_index]

		if target_item == "":
			GameGlue.ItemManager.slots[target_index] = selected_item
			GameGlue.ItemManager.emit_signal("inventory_updated")
		else:
			GameGlue.ItemManagaer.slots[target_index] = selected_item
			GameGlue.ItemManager.slots[drag_origin_index] = target_item
			GameGlue.ItemManagaer.emit_signal("inventory_updated")

		GameGlue.ItemManager.slots[GameGlue.ItemManager.cursor_slot] = ""
		GameGlue.ItemManager.update_cursor_icon()
		end_selection()
		return

	if hovered and hovered.is_in_group("targets"):
		GameGlue.ItemManager.use_item(hovered)
		end_selection()
		return

	return_item_to_inventory()

func handle_click_release():
	print("[Menu] click_release detected")
	if GameGlue.SettingsManager.item_mode != GameGlue.SettingsManager.ItemMode.SWITCH:
		return

	if selected_item != "" and not mouse_over_background and not dragging:
		print("if selected_item !=  and not mouse_over_background and not dragging")
		handle_release()

func handle_drag_release():
	if not dragging or selected_item == null:
		return
	print("[Menu] handle_drag_release called → dragging =", dragging, "selected_item =", selected_item)

	await get_tree().process_frame
	handle_release()


func handle_right_click_release():
	print("[Menu] right_click detected → end_selection")
	end_selection()

#Drag

func check_drag_state():
	var left_pressed = Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT)
	if dragging and not left_pressed:
		print("[Menu] _check_drag_button_state → button not pressed, forcing drag release")
		handle_drag_release()

func start_drag(slot_index: int, item_id: String):
	print("[DEBUG] start_drag → slot:", slot_index, 
		"item_id:", item_id, 
		"selected_item:", selected_item, 
		"cursor_slot:", GameGlue.ItemManager.slots[GameGlue.ItemManager.cursor_slot], 
		"cursor_visible:", GameGlue.ItemManager.item_cursor.visible)
	selected_item = item_id
	drag_origin_index = slot_index
	drag_consumed = false
	dragging = true

	GameGlue.ItemManager.slots[GameGlue.ItemManager.cursor_slot] = item_id
	GameGlue.ItemManager.slots[slot_index] = ""
	GameGlue.ItemManager.update_cursor_icon()
	GameGlue.ItemManager.emit_signal("inventory_updated")


func end_drag(target_node = null):
	if selected_item == null:
		return

	drag_consumed = true

	if target_node:
		GameGlue.ItemManager.use_item(target_node)
	else:
		if drag_origin_index != -1:
			GameGlue.ItemManager.slots[drag_origin_index] = selected_item
			GameGlue.ItemManager.slots[GameGlue.ItemManager.cursor_slot] = ""
			GameGlue.ItemManager.emit_signal("inventory_updated")

	end_selection()

func end_selection():
	get_tree().paused = false
	drag_origin_index = -1
	selected_item = ""
	dragging = false
