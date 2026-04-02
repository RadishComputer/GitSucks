extends CanvasLayer

func _ready():
	$TextureRect/Full/AnimatedSprite2D.animation_finished.connect(ani_fin)
	$TextureRect/Full/AnimatedSprite2D.play("logo_loop")

func fade_in_label():
	var label = $TextureRect/Full/RichTextLabel
	label.modulate.a = 0.0   
	label.show()

	var tween = get_tree().create_tween()
	tween.tween_property(label, "modulate:a", 1.0, 5.0)

func ani_fin():
	fade_in_label()
	$AudioStreamPlayer.play()
	await get_tree().create_timer(4).timeout
	fade_to_black()

func fade_to_black():
	var full = $TextureRect/Full
	var tween = get_tree().create_tween()
	full.modulate.a = 1.0
	tween.tween_property(full, "modulate:a", 0.0, 1.5)
	tween.finished.connect(opening_fin)

func opening_fin():
	GameGlue.load_scene("res://Scenes/Summery.tscn")
	queue_free()
