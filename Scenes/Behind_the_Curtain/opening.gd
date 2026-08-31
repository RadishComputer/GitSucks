extends Control

enum Step {
	ANIMATION,
	FADE_TO_BLACK,
	AUSTRALIA,
	FINISHED
}

var current_step: Step = Step.ANIMATION
var active_tween: Tween = null

func _ready() -> void:
	$CanvasLayer/TextureRect/Full/AnimatedSprite2D.animation_finished.connect(ani_fin)
	$CanvasLayer/TextureRect/Full/AnimatedSprite2D.play("default")
	
	await get_tree().create_timer(0.5).timeout
	if current_step != Step.ANIMATION:
		return
	
	GameGlue.FXPlayer.stream = preload("res://Sounds/RC_Startup.wav")
	GameGlue.FXPlayer.play()

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		skip()
	elif event.is_action_pressed("ui_accept"):
		skip()

func skip() -> void:
	if GameGlue.FXPlayer.playing:
		GameGlue.FXPlayer.stop()
	if active_tween and active_tween.is_valid():
		active_tween.kill()
		active_tween = null
	
	match current_step:
		Step.ANIMATION:
			var anim = $CanvasLayer/TextureRect/Full/AnimatedSprite2D
			anim.stop()
			var frame_count = anim.sprite_frames.get_frame_count(anim.animation)
			anim.frame = frame_count - 1

			var label = $CanvasLayer/TextureRect/Full/RichTextLabel
			label.modulate.a = 1.0
			label.show()
			fade_to_black()

		Step.FADE_TO_BLACK:
			$CanvasLayer/TextureRect/Full.modulate.a = 0.0
			fade_to_aus()

		Step.AUSTRALIA:
			var sa = $CanvasLayer/TextureRect/Screen_Australia
			sa.modulate.a = 0.0
			opening_fin()
		_:
			pass

func fade_in_label() -> void:
	var label = $CanvasLayer/TextureRect/Full/RichTextLabel
	label.modulate.a = 0.0
	label.show()
	active_tween = get_tree().create_tween()
	active_tween.tween_property(label, "modulate:a", 1.0, 5.0)
	active_tween.tween_callback(func():
		await get_tree().create_timer(4.0).timeout
		if current_step == Step.ANIMATION:
			fade_to_black()
	)

func ani_fin() -> void:
	fade_in_label()

func fade_to_black() -> void:
	current_step = Step.FADE_TO_BLACK
	var full = $CanvasLayer/TextureRect/Full
	
	active_tween = get_tree().create_tween()
	full.modulate.a = 1.0
	active_tween.tween_property(full, "modulate:a", 0.0, 1.5)
	active_tween.tween_callback(fade_to_aus)

func fade_to_aus() -> void:
	current_step = Step.AUSTRALIA
	var sa = $CanvasLayer/TextureRect/Screen_Australia
	sa.modulate.a = 0.0
	sa.show()
	
	active_tween = get_tree().create_tween()
	active_tween.tween_property(sa, "modulate:a", 1.0, 5.0)
	active_tween.tween_property(sa, "modulate:a", 0.0, 1.5)
	active_tween.tween_callback(opening_fin)

func opening_fin() -> void:
	current_step = Step.FINISHED
	GameGlue.load_scene("res://Scenes/Behind_the_Curtain/Start_Screen.tscn")
	queue_free()
