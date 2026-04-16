extends AudioStreamPlayer

var generator = AudioStreamGenerator.new()
var playback : AudioStreamGeneratorPlayback
var sample_rate = 44100

func _ready():
	print("Node name:", name)
	print("Parent:", get_parent())
	print("Assigning generator...")
	generator.mix_rate = sample_rate
	stream = generator

	print("Stream after assign:", stream)

	play()
	print("Is playing:", playing)

	playback = get_stream_playback()
	print("Playback:", playback)

	if playback:
		print("Pushing tone...")
		play_test_tone()
	else:
		print("Playback is null, cannot push tone")


func play_test_tone():
	var total_samples = sample_rate
	var data = PackedVector2Array()
	data.resize(total_samples)

	for i in range(total_samples):
		var t = float(i) / sample_rate
		var sample = sin(2.0 * PI * 440.0 * t) * 0.8
		data[i] = Vector2(sample, sample)

	playback.push_buffer(data)
