extends Control

@onready var ClockManager = GameGlue.ClockManager
@onready var KnowledgeManager = GameGlue.KnowledgeManager
@onready var SequenceMachine = GameGlue.SequenceMachine
@onready var InputManager = GameGlue.InputManager


func _ready():
	ClockManager.distance_from_church = 8
	ClockManager.update_chime_volume()
	ClockManager.update_clock_display()
	ClockManager.update_lights(self)
	ClockManager.set_front_lamp_default()
	update_upstairs_shader()
	await get_tree().process_frame
	ClockManager.church_bell()
	#ClockManager.set_front_lamp_default()

	$Back.input_event.connect(on_exit.bind("res://Scenes/Winter_House/Upstairs.tscn", true))
	$Art.input_event.connect(cactus_clicked)

func cactus_clicked(viewport, event, shape_idx):
	if InputManager.click_release(event):
		if not KnowledgeManager.secretly_knows("Cactus"):
			SequenceMachine.run_sequence([
				"dialog:1058",
				"action:secretly_learn:Cactus"
			], self)
		else:
			SequenceMachine.run_sequence(["dialog:1059"], self)

func on_exit(viewport, event, shape_idx, scene_path: String, advance_time: bool):
	if InputManager.click_release(event):
		ClockManager.next_scene_path = scene_path
		ClockManager.switch_scene(advance_time)

#Lamp Lighting

func update_upstairs_shader():
	var enabled = KnowledgeManager.secretly_knows("Upstairs_Lamp_On")
	$Lamp_Light.material.set_shader_parameter("light_enabled", enabled)
