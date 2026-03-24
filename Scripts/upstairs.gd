#Upstairs

extends Control

func _ready():
	ClockManager.distance_from_church = 8
	ClockManager.update_chime_volume()
	ClockManager.update_clock_display()
	update_time_of_day_shader()
	update_upstairs_shader()
	ClockManager.set_front_lamp_default()
	await get_tree().process_frame
	ClockManager.check_and_play_chime()
	ClockManager.set_front_lamp_default()

	$Bear_Room.input_event.connect(on_exit.bind("res://Scenes/Bear_Room.tscn", false))
	$Down_Stairs.input_event.connect(on_exit.bind("res://Scenes/Front_Room.tscn", false))
	$Lamp.input_event.connect(lamp_clicked)
	$Flower.input_event.connect(flower_clicked)
	$Drawer.input_event.connect(drawer_clicked)
	$Mirror.input_event.connect(on_exit.bind("res://Scenes/Mirror.tscn", false))
	$Bedroom.input_event.connect(bedroom_clicked)
	$Window.input_event.connect(window_clicked)
	$Attic.input_event.connect(attic_clicked)
	$Bridge.input_event.connect(on_exit.bind("res://Scenes/Art_Bridge.tscn", false))
	$Cactus.input_event.connect(on_exit.bind("res://Scenes/Art_Cactus.tscn", false))
	$Couple.input_event.connect(on_exit.bind("res://Scenes/Art_Couple.tscn", false))
	$Abstract.input_event.connect(on_exit.bind("res://Scenes/Art_Abstract.tscn", false))
	$Tree.input_event.connect(on_exit.bind("res://Scenes/Art_Tree.tscn", false))
	$Lavender.input_event.connect(on_exit.bind("res://Scenes/Art_Lanvender.tscn", false))
	$Rainier.input_event.connect(on_exit.bind("res://Scenes/Art_Ranier.tscn", false))
	$Mom.input_event.connect(on_exit.bind("res://Scenes/Art_Mom.tscn", false))
	$Babys_Breath.input_event.connect(on_exit.bind("res://Scenes/Art_Babys_Breath.tscn", false))
	$Falls.input_event.connect(on_exit.bind("res://Scenes/Art_Falls.tscn", false))
	$Someone.input_event.connect(on_exit.bind("res://Scenes/Art_Someone.tscn", false))
	$Dad.input_event.connect(on_exit.bind("res://Scenes/Art_Dad.tscn", false))

func drawer_clicked(viewport, event, shape_idx):
	if InputManager.click_release(event):
		if not KnowledgeManager.knows("Little_Guy_Collected"):
			ItemManager.add_item("little_guy")
			SequenceMachine.run_sequence([
				"dialog:1076",
				"note:[center]Summer Found A Little Guy[/center]",
				"action:learn:Little_Guy_Collected"
			], self)
		else:
			SequenceMachine.run_sequence(["dialog:1043"], self)

func window_clicked(viewport, event, shape_idx):
	if InputManager.click_release(event):
		if not KnowledgeManager.secretly_knows("Window_Tried"):
			SequenceMachine.run_sequence([
				"dialog:1030",
				"action:secretly_learn:Window_Tried"
			], self)
		else:
			SequenceMachine.run_sequence(["dialog:1031"], self)

func flower_clicked(viewport, event, shape_idx):
	if InputManager.click_release(event):
		SequenceMachine.run_sequence(["dialog:1053"], self)

func bedroom_clicked(viewport, event, shape_idx):
	if InputManager.click_release(event):
		SequenceMachine.run_sequence(["dialog:1055"], self)

func attic_clicked(viewport, event, shape_idx):
	if InputManager.click_release(event):
		SequenceMachine.run_sequence(["dialog:1056"], self)

func on_exit(viewport, event, shape_idx, scene_path: String, advance_time: bool):
	if InputManager.click_release(event):
		ClockManager.next_scene_path = scene_path
		if advance_time:
			ClockManager.switch_scene(true)
		else:
			get_tree().change_scene_to_file(scene_path)
		print("Going to %s" % scene_path)
		ClockManager.set_front_lamp_default()

func update_time_of_day_shader():
	var tint = ClockManager.get_time_of_day_tint()
	var strength = ClockManager.get_time_of_day_strength()

	$Time_of_Day.material.set_shader_parameter("tint_color", tint)
	$Time_of_Day.material.set_shader_parameter("strength", strength)

#Lamp Lighting

func lamp_clicked(viewport, event, shape_idx):
	if InputManager.click_release(event):
		if KnowledgeManager.secretly_knows("Upstairs_Lamp_On"):
			KnowledgeManager.secretly_forget("Upstairs_Lamp_On")
		else:
			KnowledgeManager.secretly_learn("Upstairs_Lamp_On")
		update_upstairs_shader()

func update_upstairs_shader():
	var enabled = KnowledgeManager.secretly_knows("Upstairs_Lamp_On")
	$Lamp_Light.material.set_shader_parameter("light_enabled", enabled)
