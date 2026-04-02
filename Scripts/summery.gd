#Summery

extends Control

@onready var fade_layer = $Self
@onready var click_hint = $NoteBox/Center/Click_Hint
@onready var light_sound = $Light
@onready var outro_sound = $Outro

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

var first_click = false
var flashing = false

func _ready():
	GameGlue.DialogManager.reset_dialog_state()
	await get_tree().process_frame

	$IrisMask.material.set("shader_parameter/center", Vector2(0, 0))
	$IrisMask.visible = true

	await wait_for_click()

	#Reveal
	await iris_open()
	$Self.visible = true


	await wait_for_click()

	#Standup
	await SequenceMachine.run_sequence([
		"dialog:1019",
		"action:finish_scene"
	], self)

func finish_scene():
	await iris_expand_to_blue()
	$IrisMask.z_index = 5
	await iris_close()
	await get_tree().create_timer(1.0).timeout
	GameGlue.load_scene("res://Scenes/Bear_Room.tscn")

func fade_out_overlay():
	var tween = create_tween()
	tween.tween_property(fade_layer, "modulate:a", 0.0, 1.5)\
		.set_trans(Tween.TRANS_SINE)\
		.set_ease(Tween.EASE_IN_OUT)
	await tween.finished

func iris_open():
	light_sound.play()
	await get_tree().create_timer(0.1).timeout
	$Self.visible = true
	$IrisMask.visible = true
	$IrisMask.material.set("shader_parameter/radius", 340)
	Bouncer.bounce($Self)

func iris_close():
	var tween = create_tween()
	tween.tween_property($IrisMask.material, "shader_parameter/radius", 0.0, 1.0)\
		.set_trans(Tween.TRANS_SINE)\
		.set_ease(Tween.EASE_IN)
	await tween.finished

func iris_expand_to_blue():
	outro_sound.play()
	var tween = create_tween()
	tween.tween_property($IrisMask.material, "shader_parameter/radius",1200, 1.0)
	await tween.finished

func wait_for_click():
	await get_tree().process_frame

	if first_click:
		while true:
			await get_tree().process_frame
			if Input.is_action_just_released("click"):
				return
		return

	var timer = get_tree().create_timer(10.0)

	while true:
		await get_tree().process_frame

		if Input.is_action_just_released("click"):
			first_click = true
			stop_flashing_hint()
			return

		if timer.time_left == 0 and not flashing:
			start_flashing_hint()

func start_flashing_hint():
	flashing = true
	click_hint.visible = true
	click_hint.modulate.a = 1.0
	flash_hint()

func flash_hint() -> void:
	await get_tree().process_frame

	while flashing:
		var t = create_tween()
		t.tween_property(click_hint, "modulate:a", 1.0, 0.5)
		await t.finished
		if not flashing:
			break

		t = create_tween()
		t.tween_property(click_hint, "modulate:a", 0.2, 0.5)
		await t.finished

func stop_flashing_hint():
	flashing = false
	click_hint.visible = false
	click_hint.modulate.a = 1.0
