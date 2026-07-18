extends Control

@onready var PhoneAudio = GameGlue.PhoneAudio
@onready var PhoneBook = GameGlue.PhoneBook
@onready var DialogManager = GameGlue.DialogManager
@onready var ItemDatabase = GameGlue.ItemDatabase
@onready var ClockManager = GameGlue.ClockManager
@onready var GameState = GameGlue.GameState
@onready var NumberManager = GameGlue.NumberManager
@onready var KnowledgeManager = GameGlue.KnowledgeManager
@onready var SettingsManager = GameGlue.SettingsManager
@onready var SequenceMachine = GameGlue.SequenceMachine
@onready var Bouncer = GameGlue.Bouncer
@onready var Menu = GameGlue.Menu
@onready var InputManager = GameGlue.InputManager
@onready var PortraitManager = GameGlue.PortraitManager
@onready var ItemManager = GameGlue.ItemManager
@onready var TextBox = GameGlue.TextBox

@export var locker_id: String = "Locker_01"

@onready var dial1 = $Number_Disk1
@onready var dial2 = $Number_Disk2
@onready var dial3 = $Number_Disk3

var current_combo = [0, 0, 0]
var correct_combo = [0, 0, 0]

func _ready():
	current_combo = GameGlue.GameState.get_locker_state(locker_id).duplicate()
	correct_combo = GameGlue.GameState.get_locker_solution(locker_id)
	
	dial1.dial_changed.connect(dial_changed.bind(0))
	dial2.dial_changed.connect(dial_changed.bind(1))
	dial3.dial_changed.connect(dial_changed.bind(2))
	
	update_dials_visual_instant()

	$Back.input_event.connect(on_exit.bind("res://Scenes/Pins_Interior/Pins_Lockers.tscn", false))
	$Knob.input_event.connect(knob_turned)

func update_dials_visual_instant():
	dial1.get_mesh().rotation_degrees.x = current_combo[0] * 36
	dial2.get_mesh().rotation_degrees.x = current_combo[1] * 36
	dial3.get_mesh().rotation_degrees.x = current_combo[2] * 36

func dial_changed(value: int, index: int):
	current_combo[index] = value
	GameGlue.GameState.save_locker_state(locker_id, current_combo)
	#GameGlue.PhoneAudio.play_sound("click")

func check_combination():
	if current_combo == correct_combo:
		print("SUCCESS! Locker Opening...")
		open_locker()
	else:
		print("CLUNK. Wrong code.")

func open_locker():
	GameGlue.ClockManager.next_scene_path = "res://Scenes/Pins_Interior/Lockers/Locker_14i.tscn"
	GameGlue.ClockManager.switch_scene(false)

func knob_turned(viewport, event, shape_idx):
	if InputManager.click_release(event):
		check_combination()

func get_mesh():
	return $SubViewport/DialMesh

func update_dials_visual():
	dial1.get_mesh().rotation_degrees.x = current_combo[0] * 36
	dial2.get_mesh().rotation_degrees.x = current_combo[1] * 36
	dial3.get_mesh().rotation_degrees.x = current_combo[2] * 36

func on_dial_clicked(index: int):
	current_combo[index] = (current_combo[index] + 1) % 10

	var target_dial = [dial1, dial2, dial3][index]
	var target_mesh = target_dial.get_mesh()

	var tween = create_tween()
	tween.tween_property(target_mesh, "rotation_degrees:x", current_combo[index] * 36, 0.2)\
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)

	GameGlue.GameState.save_locker_state(locker_id, current_combo)
	#GameGlue.PhoneAudio.play_sound("click")

func dial_spun(direction: int, index: int):
	current_combo[index] = (current_combo[index] + direction + 10) % 10
	update_single_dial_visual(index)

func update_single_dial_visual(index: int):
	var target_dial = [dial1, dial2, dial3][index]
	var target_mesh = target_dial.get_mesh()
	var tween = create_tween()
	var target_rotation = current_combo[index] * 36
	tween.tween_property(target_mesh, "rotation_degrees:x", target_rotation, 0.2)\
		.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	GameGlue.GameState.save_locker_state(locker_id, current_combo)

func on_exit(viewport, event, shape_idx, scene_path: String, advance_time: bool):
	if InputManager.click_release(event):
		ClockManager.next_scene_path = scene_path
		ClockManager.switch_scene(advance_time)
