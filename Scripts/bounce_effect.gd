extends RichTextEffect
class_name BounceEffect

var bbcode = "bounce"

func _process_custom_fx(char_fx: CharFXTransform) -> bool:
	var t = Time.get_ticks_msec() / 1000.0
	var start_time := float(char_fx.env.get("start_time", t))
	var age = t - start_time

	var offset = sin(age * 20.0) * exp(-age * 6.0) * 24.0
	if age > 0.3:
		offset = 0.0

	char_fx.offset.y -= offset
	return true
