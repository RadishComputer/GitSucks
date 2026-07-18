extends SubViewportContainer

signal dial_changed(new_value: int)

@onready var mesh = $SubViewport/MeshInstance3D

var dragging = false
var last_mouse_y = 0.0
var sensitivity = 0.5
var snap_tween: Tween

func _ready():
	for child in $SubViewport.get_children():
		if child is MeshInstance3D and child != mesh:
			child.queue_free()
			print("Ghost Deleted from ", name)

func _gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				if snap_tween and snap_tween.is_running():
					snap_tween.kill()
				
				dragging = true
				last_mouse_y = get_local_mouse_position().y
			else:
				dragging = false
				snap_to_nearest()
			accept_event()

	if event is InputEventMouseMotion and dragging:
		var current_mouse_y = get_local_mouse_position().y
		var delta_y = current_mouse_y - last_mouse_y
		last_mouse_y = current_mouse_y
		mesh.rotation_degrees.x -= delta_y * sensitivity

func snap_to_nearest():
	var current_rot = mesh.rotation_degrees.x
	var nearest_index = round(current_rot / 36.0)
	var target_rot = nearest_index * 36.0
	
	snap_tween = create_tween()
	snap_tween.tween_property(mesh, "rotation_degrees:x", target_rot, 0.15)\
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)

	var final_value = posmod(int(nearest_index), 10)
	print("Disk ", name, " digit updated to: ", final_value)
	emit_signal("dial_changed", final_value)

func get_mesh():
	return mesh
