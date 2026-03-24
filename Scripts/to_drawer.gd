extends Area2D

func _input_event(viewport, event, shape_idx):
	if InputManager.click_release(event):
		print("You opened the drawer.")
		ClockManager.next_scene_path = "res://Bear_Room_Drawer.tscn"
		ClockManager.switch_scene(true)
