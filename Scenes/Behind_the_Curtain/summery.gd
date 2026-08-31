#Summery

extends Control

@onready var fade_layer = $Self
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

func _ready():
	GameGlue.DialogManager.reset_dialog_state()
	await get_tree().process_frame

	$IrisMask.material.set("shader_parameter/center", Vector2(0, 0))
	$IrisMask.visible = true

	await get_tree().create_timer(1.0).timeout
	SequenceMachine.run_sequence([
		"note:[center]Three Days Later[/center]:none",
	], self)
	await wait_for_click()

#Reveal

	await get_tree().create_timer(1.0).timeout
	await iris_open()
	$Self.visible = true

	await wait_for_click()

#Standup

	await SequenceMachine.run_sequence([
		"dialog:1019",
		"action:finish_scene"
	], self)

func bounce_summer():
	Bouncer.bounce($Self)

func finish_scene():
	await iris_expand_to_blue()
	$IrisMask.z_index = 5
	await iris_close()
	await get_tree().create_timer(1.0).timeout
	GameGlue.load_scene("res://Scenes/Winter_House/Bear_Room.tscn")

func fade_out_overlay():
	var tween = create_tween()
	tween.tween_property(fade_layer, "modulate:a", 0.0, 1.5)\
		.set_trans(Tween.TRANS_SINE)\
		.set_ease(Tween.EASE_IN_OUT)
	await tween.finished

func iris_open():
	GameGlue.stop_ambience()
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

	var tween = create_tween()
	tween.tween_property($IrisMask.material, "shader_parameter/radius",1200, 1.0)
	outro_sound.play()
	await tween.finished

func wait_for_click():
	await get_tree().process_frame

	while true:
		await get_tree().process_frame
		if Input.is_action_just_released("click"):
			return
