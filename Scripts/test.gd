extends Control

@onready var tint_mask = $TintMask

func _ready():
	set_time_of_day("day")

	$Day.pressed.connect(func(): set_time_of_day("day"))
	$Evening.pressed.connect(func(): set_time_of_day("evening"))
	$Night.pressed.connect(func(): set_time_of_day("night"))
	$Morning.pressed.connect(func(): set_time_of_day("morning"))

func set_time_of_day(time: String):
	match time:
		"day":
			tint_mask.material.set("shader_parameter/tint_color", Color(1, 1, 1, 0)) # transparent
		"evening":
			tint_mask.material.set("shader_parameter/tint_color", Color(1, 0.85, 0.7, 0.4)) # warm
		"night":
			tint_mask.material.set("shader_parameter/tint_color", Color(0.4, 0.5, 0.9, 0.6)) # cool
		"morning":
			tint_mask.material.set("shader_parameter/tint_color", Color(1, 0.95, 0.85, 0.4)) # soft
