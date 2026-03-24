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

	$Back.input_event.connect(on_exit.bind("res://Scenes/Upstairs.tscn", false))
	$Art.input_event.connect(falls_clicked)

func falls_clicked(viewport, event, shape_idx):
	if InputManager.click_release(event):
		SequenceMachine.run_sequence(["dialog:1073"], self)

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

func update_upstairs_shader():
	var enabled = KnowledgeManager.secretly_knows("Upstairs_Lamp_On")
	$Lamp_Light.material.set_shader_parameter("light_enabled", enabled)
