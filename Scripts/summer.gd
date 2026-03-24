extends Control

@onready var eye_one = $Summer/Eye1
@onready var eye_two = $Summer/Eye2
@onready var dead_zone = $Dead_Zone

@export var radius = 140.0
@export var speed  = 3.0
@export var offset = deg_to_rad(180)

var neutral_one: float
var neutral_two: float

func _ready():
	neutral_one = eye_one.rotation
	neutral_two = eye_two.rotation

func _process(delta):
	var dir = get_global_mouse_position() - dead_zone.global_position
	var target: float

	if dir.length() < radius:
		eye_one.rotation = lerp_angle(eye_one.rotation, neutral_one, delta * speed)
		eye_two.rotation = lerp_angle(eye_two.rotation, neutral_two, delta * speed)
		return
	else:
		target = dir.angle() + offset
	eye_one.rotation = lerp_angle(eye_one.rotation, target, delta * speed)
	eye_two.rotation = lerp_angle(eye_two.rotation, target, delta * speed)
