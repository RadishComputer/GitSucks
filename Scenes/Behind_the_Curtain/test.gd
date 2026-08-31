extends Control

@onready var audio = $AudioStreamPlayer
@onready var label = $Label

var presets = {
	"Arch": preload("res://Sounds/Arch.wav"),
	"Beep": preload("res://Sounds/Beep.wav"),
	"Bep": preload("res://Sounds/Bep.wav"),
	"Blow": preload("res://Sounds/Blow.wav"),
	"Bong": preload("res://Sounds/Bong.wav"),
	"Bonk": preload("res://Sounds/Bonk.wav"),
	"Bub": preload("res://Sounds/Bub.wav"),
	"Bump": preload("res://Sounds/Bump.wav"),
	"Buzz": preload("res://Sounds/Buzz.wav"),
	"Clank": preload("res://Sounds/Clank.wav"),
	"Clap": preload("res://Sounds/Clap.wav"),
	"Click": preload("res://Sounds/Clink.wav"),
	"Crunch": preload("res://Sounds/Crunch.wav"),
	"Cunk": preload("res://Sounds/Cunk.wav"),
	"Doink": preload("res://Sounds/Doink.wav"),
	"Drag": preload("res://Sounds/Drag.wav"),
	"Drop": preload("res://Sounds/Drop.wav"),
	"Fizz": preload("res://Sounds/Fizz.wav"),
	"Flap": preload("res://Sounds/Flap.wav"),
	"Flip": preload("res://Sounds/Flip.wav"),
	"Flop": preload("res://Sounds/Flop.wav"),
	"Flute": preload("res://Sounds/Flute.wav"),
	"Gong": preload("res://Sounds/Gong.wav"),
	"Harp": preload("res://Sounds/Harp.wav"),
	"Honk": preload("res://Sounds/Honk.wav"),
	"Horn": preload("res://Sounds/Horn.wav"),
	"Howl": preload("res://Sounds/Howl.wav"),
	"Kick": preload("res://Sounds/Kick.wav"),
	"Knock": preload("res://Sounds/Knock.wav"),
	"Long": preload("res://Sounds/Long.wav"),
	"Piano": preload("res://Sounds/Piano.wav"),
	"Ping": preload("res://Sounds/Ping.wav"),
	"Pip": preload("res://Sounds/Pip.wav"),
	"Plop": preload("res://Sounds/Plop.wav"),
	"Pop": preload("res://Sounds/Pop.wav"),
	"Slap": preload("res://Sounds/Slap.wav"),
	"Smash": preload("res://Sounds/Smash.wav"),
	"Sniff": preload("res://Sounds/Sniff.wav"),
	"Snow": preload("res://Sounds/Snow.wav"),
	"Spin": preload("res://Sounds/Spin.wav"),
	"Spit": preload("res://Sounds/Spit.wav"),
	"Squawk": preload("res://Sounds/Squawk.wav"),
	"Squeak": preload("res://Sounds/Squeak.wav"),
	"Squeal": preload("res://Sounds/Squeal.wav"),
	"Static": preload("res://Sounds/Static.wav"),
	"Sweep": preload("res://Sounds/Sweep.wav"),
	"Tap": preload("res://Sounds/Tap.wav"),
	"Thud": preload("res://Sounds/Thud.wav"),
	"Tin": preload("res://Sounds/Tin.wav"),
	"Tock": preload("res://Sounds/Tock.wav"),
	"Tone": preload("res://Sounds/Tone.wav"),
	"Top": preload("res://Sounds/Top.wav"),
	"Truck": preload("res://Sounds/Truck.wav"),
	"Twang": preload("res://Sounds/Twang.wav"),
	"Tip": preload("res://Sounds/Tip.wav"),
	"Type": preload("res://Sounds/Type.wav"),
	"Warp": preload("res://Sounds/Warp.wav"),
	"Wheeze": preload("res://Sounds/Wheeze.wav"),
	"Wind": preload("res://Sounds/Wind.wav"),
	"Wiz": preload("res://Sounds/Wiz.wav"),
	"Woosh": preload("res://Sounds/Woosh.wav"),
}

var preset_names = []
var index = 0

func _ready():
	$Button_Play.pressed.connect(play_button)
	$Button_Next.pressed.connect(next_button)
	$Button_Prev.pressed.connect(prev_button)

	preset_names = presets.keys()
	update_label()

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
