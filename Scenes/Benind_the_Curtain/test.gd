extends Control

@onready var tint_mask = $TintMask
@onready var audio = $AudioStreamPlayer
@onready var label = $Label

@onready var canvas_modulate = $CanvasModulate

var presets = {
	"Arch": preload("res://sounds/Arch.wav"),
	"Beep": preload("res://sounds/Beep.wav"),
	"Bep": preload("res://sounds/Bep.wav"),
	"Blow": preload("res://sounds/Blow.wav"),
	"Bong": preload("res://sounds/Bong.wav"),
	"Bonk": preload("res://sounds/Bonk.wav"),
	"Bub": preload("res://sounds/Bub.wav"),
	"Bump": preload("res://sounds/Bump.wav"),
	"Buzz": preload("res://sounds/Buzz.wav"),
	"Clank": preload("res://sounds/Clank.wav"),
	"Clap": preload("res://sounds/Clap.wav"),
	"Click": preload("res://Sounds/Clink.wav"),
	"Crunch": preload("res://sounds/Crunch.wav"),
	"Cunk": preload("res://sounds/Cunk.wav"),
	"Doink": preload("res://sounds/Doink.wav"),
	"Drag": preload("res://sounds/Drag.wav"),
	"Drop": preload("res://sounds/Drop.wav"),
	"Fizz": preload("res://sounds/Fizz.wav"),
	"Flap": preload("res://sounds/Flap.wav"),
	"Flip": preload("res://sounds/Flip.wav"),
	"Flop": preload("res://sounds/Flop.wav"),
	"Flute": preload("res://sounds/Flute.wav"),
	"Gong": preload("res://sounds/Gong.wav"),
	"Harp": preload("res://sounds/Harp.wav"),
	"Honk": preload("res://sounds/Honk.wav"),
	"Horn": preload("res://sounds/Horn.wav"),
	"Howl": preload("res://sounds/Howl.wav"),
	"Kick": preload("res://sounds/Kick.wav"),
	"Knock": preload("res://sounds/Knock.wav"),
	"Long": preload("res://sounds/Long.wav"),
	"Piano": preload("res://sounds/Piano.wav"),
	"Ping": preload("res://sounds/Ping.wav"),
	"Pip": preload("res://sounds/Pip.wav"),
	"Plop": preload("res://sounds/Plop.wav"),
	"Pop": preload("res://sounds/Pop.wav"),
	"Slap": preload("res://sounds/Slap.wav"),
	"Smash": preload("res://sounds/Smash.wav"),
	"Sniff": preload("res://sounds/Sniff.wav"),
	"Snow": preload("res://sounds/Snow.wav"),
	"Spin": preload("res://sounds/Spin.wav"),
	"Spit": preload("res://sounds/Spit.wav"),
	"Squawk": preload("res://sounds/Squawk.wav"),
	"Squeak": preload("res://sounds/Squeak.wav"),
	"Squeal": preload("res://sounds/Squeal.wav"),
	"Static": preload("res://sounds/Static.wav"),
	"Sweep": preload("res://sounds/Sweep.wav"),
	"Tap": preload("res://sounds/Tap.wav"),
	"Thud": preload("res://sounds/Thud.wav"),
	"Tin": preload("res://sounds/Tin.wav"),
	"Tock": preload("res://sounds/Tock.wav"),
	"Tone": preload("res://sounds/Tone.wav"),
	"Top": preload("res://sounds/Top.wav"),
	"Truck": preload("res://sounds/Truck.wav"),
	"Twang": preload("res://sounds/Twang.wav"),
	"Tip": preload("res://Sounds/Tip.wav"),
	"Type": preload("res://sounds/Type.wav"),
	"Warp": preload("res://sounds/Warp.wav"),
	"Wheeze": preload("res://sounds/Wheeze.wav"),
	"Wind": preload("res://sounds/Wind.wav"),
	"Wiz": preload("res://sounds/Wiz.wav"),
	"Woosh": preload("res://sounds/Woosh.wav"),


	# Add all your character sounds here
}

var preset_names = []
var index = 0

func _ready():
	set_time_of_day("day")

	$Day.pressed.connect(func(): set_time_of_day("day"))
	$Evening.pressed.connect(func(): set_time_of_day("evening"))
	$Night.pressed.connect(func(): set_time_of_day("night"))
	$Morning.pressed.connect(func(): set_time_of_day("morning"))

	$Button_Play.pressed.connect(play_button)
	$Button_Next.pressed.connect(next_button)
	$Button_Prev.pressed.connect(prev_button)

	preset_names = presets.keys()
	update_label()

func set_time_of_day(time: String):
	match time:
		"day":
			canvas_modulate.color = Color(1, 1, 1, 1)  # no tint
		"evening":
			canvas_modulate.color = Color(1.1, 0.85, 0.7, 1)  # warm
		"night":
			canvas_modulate.color = Color(0.4, 0.5, 0.9, 1)  # cool
		"morning":
			canvas_modulate.color = Color(1.05, 0.95, 0.85, 1)  # soft

func update_label():
	label.text = "%s" % preset_names[index]

func next_button():
	index = (index + 1) % preset_names.size()
	update_label()

func prev_button():
	index = (index - 1 + preset_names.size()) % preset_names.size()
	update_label()

func play_button():
	play_sentence()

func play_sentence():
	var sentence = "The quick brown fox jumps over the lazy dog."
	var chars = sentence.split("")
	var sound = presets[preset_names[index]]

	for c in chars:
		if c != " ":
			audio.stream = sound
			audio.play()
		await get_tree().create_timer(0.05).timeout
