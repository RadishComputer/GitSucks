extends Control

@onready var intro_blocker = $Intro_Blocker

func _ready():
	ClockManager.distance_from_church = 8
	ClockManager.update_chime_volume()
	ClockManager.update_clock_display()
	update_time_of_day_shader()
	update_light_shader()
	await get_tree().process_frame
	ClockManager.check_and_play_chime()

	if KnowledgeManager.knows("Start_The_Game_Already"):
		intro_blocker.visible = false
	else:
		SequenceMachine.run_sequence([
			"dialog:1025",
			"note:[center]Start The Game Already[/center]",
			"action:intro_finished",
		], self)

	$Under_Bed.input_event.connect(under_bed_clicked)
	$Desk.input_event.connect(desk_clicked)
	$Window.input_event.connect(window_clicked)
	$Drawer1.input_event.connect(drawer1_clicked.bind("res://Scenes/Bear_Room_Drawer.tscn", true))
	$Drawer2.input_event.connect(drawer2_clicked)
	$Book.input_event.connect(book_clicked)
	$Closet.input_event.connect(closet_clicked)
	$Bear1.input_event.connect(bear1_clicked)
	$Bear2.input_event.connect(bear2_clicked)
	$Bear3.input_event.connect(bear3_clicked)
	$Bear4.input_event.connect(bear4_clicked)
	$Suitcase.input_event.connect(suitcase_clicked)
	$Phone.input_event.connect(phone_clicked.bind("res://Scenes/Bear_Room_Phone.tscn", true))
	$Flower.input_event.connect(flower_clicked)
	$Bed.input_event.connect(bed_clicked)
	$Lamp.input_event.connect(lamp_clicked)

func intro_finished():
	KnowledgeManager.learn("Start_The_Game_Already")
	intro_blocker.visible = false

func closet_clicked(viewport, event, shape_idx):
	if InputManager.click_release(event):
		SequenceMachine.run_sequence(["dialog:1028"], self)

func under_bed_clicked(viewport, event, shape_idx):
	if InputManager.click_release(event):
		SequenceMachine.run_sequence(["dialog:1029"], self)

func desk_clicked(viewport, event, shape_idx):
	if InputManager.click_release(event):
		SequenceMachine.run_sequence(["dialog:1032"], self)

func window_clicked(viewport, event, shape_idx):
	if InputManager.click_release(event):
		if not KnowledgeManager.secretly_knows("Window_Tried"):
			SequenceMachine.run_sequence([
				"dialog:1030",
				"action:secretly_learn:Window_Tried"
			], self)
		else:
			SequenceMachine.run_sequence(["dialog:1031"], self)

func bed_clicked(viewport, event, shape_idx):
	if InputManager.click_release(event):
		SequenceMachine.run_sequence(["dialog:1034"], self)

func book_clicked(viewport, event, shape_idx):
	if InputManager.click_release(event):
		if not KnowledgeManager.secretly_knows("Book_Look"):
			SequenceMachine.run_sequence([
				"action:secretly_learn:Book_Look",
				"dialog:1035"
			], self)
		else:
			SequenceMachine.run_sequence(["dialog:1036"], self)

func flower_clicked(viewport, event, shape_idx):
	if InputManager.click_release(event):
		SequenceMachine.run_sequence(["dialog:1037"], self)

func suitcase_clicked(viewport, event, shape_idx):
	if InputManager.click_release(event):
		SequenceMachine.run_sequence(["dialog:1038"], self)

func bear1_clicked(viewport, event, shape_idx):
	if InputManager.click_release(event):
		SequenceMachine.run_sequence(["dialog:1039"], self)

func bear2_clicked(viewport, event, shape_idx):
	if InputManager.click_release(event):
		SequenceMachine.run_sequence(["dialog:1040"], self)

func bear3_clicked(viewport, event, shape_idx):
	if InputManager.click_release(event):
		SequenceMachine.run_sequence(["dialog:1041"], self)

func bear4_clicked(viewport, event, shape_idx):
	if InputManager.click_release(event):
		SequenceMachine.run_sequence(["dialog:1042"], self)

func drawer2_clicked(viewport, event, shape_idx):
	if InputManager.click_release(event):
		SequenceMachine.run_sequence(["dialog:1043"], self)

func drawer1_clicked(viewport, event, shape_idx, scene_path: String, advance_time: bool):
	if InputManager.click_release(event):
		ClockManager.next_scene_path = scene_path
		if advance_time:
			ClockManager.switch_scene(true)
		else:
			get_tree().change_scene_to_file(scene_path)

func to_drawer():
	ClockManager.next_scene_path = "res://Scenes/Bear_Room_Drawer.tscn"
	ClockManager.switch_scene(true)

func phone_clicked(viewport, event, shape_idx, scene_path: String, advance_time: bool):
	if InputManager.click_release(event):
		ClockManager.next_scene_path = scene_path
		if advance_time:
			ClockManager.switch_scene(true)
		else:
			get_tree().change_scene_to_file(scene_path)

func go_to_phone():
	ClockManager.next_scene_path = "res://Scenes/Bear_Room_Phone.tscn"
	ClockManager.switch_scene(true)

func update_time_of_day_shader():
	var tint = ClockManager.get_time_of_day_tint()
	var strength = ClockManager.get_time_of_day_strength()
	$Time_of_Day.material.set_shader_parameter("tint_color", tint)
	$Time_of_Day.material.set_shader_parameter("strength", strength)

func lamp_clicked(viewport, event, shape_idx):
	if InputManager.click_release(event):
		if KnowledgeManager.secretly_knows("Lamp_On"):
			KnowledgeManager.secretly_forget("Lamp_On")
		else:
			KnowledgeManager.secretly_learn("Lamp_On")
		update_light_shader()

func update_light_shader():
	var enabled = KnowledgeManager.secretly_knows("Lamp_On")
	$Lamp_Light.material.set_shader_parameter("light_enabled", enabled)
