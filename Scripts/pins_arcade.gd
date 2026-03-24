extends Control

func _ready():
	ClockManager.distance_from_church = 5
	ClockManager.update_chime_volume()
	ClockManager.update_clock_display()
	await get_tree().process_frame
	ClockManager.check_and_play_chime()
	
	$To_Desk.input_event.connect(on_exit.bind("res://Scenes/Pins_Desk.tscn", false))
	$To_QoE.input_event.connect(on_exit.bind("res://Scenes/Arcade_Queens_Of_Egypt.tscn", false))
	$To_SS.input_event.connect(on_exit.bind("res://Scenes/Arcade_Steamboat_Speedway.tscn", false))
	$To_TTO.input_event.connect(on_exit.bind("res://Scenes/Arcade_Take_This_Outback.tscn", false))
	$To_TBM.input_event.connect(on_exit.bind("res://Scenes/Arcade_Travlin_Banjo_Man.tscn", false))
	$To_AA.input_event.connect(on_exit.bind("res://Scenes/Arcade_Ape_Architecht.tscn", false))

func on_exit(viewport, event, shape_idx, scene_path: String, advance_time: bool):
	if InputManager.click_release(event):
		ClockManager.next_scene_path = scene_path
		if advance_time:
			ClockManager.switch_scene(true)
		else:
			get_tree().change_scene_to_file(scene_path)
		print("Going to %s" % scene_path)
