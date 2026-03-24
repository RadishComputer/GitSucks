extends Control

func _ready():
	ClockManager.distance_from_church = 5
	ClockManager.update_chime_volume()
	ClockManager.update_clock_display()
	await get_tree().process_frame
	ClockManager.check_and_play_chime()
	
	$To_Arcade.input_event.connect(on_exit.bind("res://Scenes/Pins_Arcade.tscn", false))
	$To_Lanes.input_event.connect(on_exit.bind("res://Scenes/Pins_Lanes.tscn", false))
	$To_Lockers.input_event.connect(on_exit.bind("res://Scenes/Pins_Lockers.tscn", false))
	$Exit.input_event.connect(on_exit.bind("res://Scenes/Pioneer_At_2nd.tscn", false))

	$Phone.input_event.connect(phone_clicked)

func on_exit(viewport, event, shape_idx, scene_path: String, advance_time: bool):
	if InputManager.click_release(event):
		ClockManager.next_scene_path = scene_path
		if advance_time:
			ClockManager.switch_scene(true)
		else:
			get_tree().change_scene_to_file(scene_path)
		print("Going to %s" % scene_path)

func phone_clicked():
	print("HI")
