extends AudioStreamPlayer

var generator = AudioStreamGenerator.new()
var playback: AudioStreamGeneratorPlayback

var running = false
var dtmf_running = false
var disconnect_running = false
var howler_running = false

var sample_rate = 44100
var buffer = 2048
var phase = 0.0

var dtmf_low = 0.0
var dtmf_high = 0.0
var howler_on = true
var howler_timer = 0.0
var howler_phase = [0.0, 0.0, 0.0, 0.0]
var howler_freqs = [1400.0, 2060.0, 2450.0, 2600.0]
const HOWLER_INTERVAL = 0.1

var dtmf_table = {
	"Key1": Vector2(697.0, 1209.0),
	"Key2": Vector2(697.0, 1336.0),
	"Key3": Vector2(697.0, 1477.0),
	"Key4": Vector2(770.0, 1209.0),
	"Key5": Vector2(770.0, 1336.0),
	"Key6": Vector2(770.0, 1477.0),
	"Key7": Vector2(852.0, 1209.0),
	"Key8": Vector2(852.0, 1336.0),
	"Key9": Vector2(852.0, 1477.0),
	"Star": Vector2(941.0, 1209.0),
	"Key0": Vector2(941.0, 1336.0),
	"Pound": Vector2(941.0, 1477.0)
}

func _ready():
	generator.mix_rate = sample_rate
	stream = generator

# DIAL TONE

func push_dialtone_chunk(buffer_size: int, sample_rate: int):
	var data = PackedVector2Array()
	data.resize(buffer_size)

	for i in range(buffer_size):
		var sample = (
			sin(2.0 * PI * 350.0 * phase) * 0.05 +
			sin(2.0 * PI * 440.0 * phase) * 0.05
		)
		phase += 1.0 / sample_rate
		data[i] = Vector2(sample, sample)

	playback.push_buffer(data)


func play_dial_tone():
	if running:
		return
	running = true

	play()
	playback = get_stream_playback() as AudioStreamGeneratorPlayback

	for i in range(4):
		push_dialtone_chunk(buffer, sample_rate)

	generate_dial_tone()


func stop_dial_tone():
	running = false
	stop()


func generate_dial_tone():
	for i in range(4):
		push_dialtone_chunk(buffer, sample_rate)

	while running:
		if playback.get_frames_available() >= buffer:
			var data = PackedVector2Array()
			data.resize(buffer)

			for i in range(buffer):
				var tone = (
					sin(2.0 * PI * 350.0 * phase) * 0.05 +
					sin(2.0 * PI * 440.0 * phase) * 0.05
				)
				phase += 1.0 / sample_rate
				data[i] = Vector2(tone, tone)

			playback.push_buffer(data)

		await get_tree().process_frame

# SIT TONE

func generate_sit_tone():
	running = false
	dtmf_running = false
	disconnect_running = false
	howler_running = false

	play()
	playback = get_stream_playback()

	# Wait one frame so playback is ready
	await get_tree().create_timer(1.0).timeout

	await play_sit_tone(913.8, 0.274)
	await play_sit_tone(1370.6, 0.274)
	await play_sit_tone(1776.7, 0.380)

	# Wait for the last buffer to drain
	await get_tree().create_timer(0.1).timeout

	stop()


func play_sit_tone(freq: float, duration: float):
	var total_samples = int(duration * sample_rate)
	var samples_pushed = 0
	var chunk_size = 1024  # small chunks so generator never starves

	while samples_pushed < total_samples:
		# Wait until generator has room
		while playback.get_frames_available() < chunk_size:
			await get_tree().process_frame

		var data = PackedVector2Array()
		data.resize(chunk_size)

		for i in range(chunk_size):
			var t = float(samples_pushed + i) / sample_rate
			var sample = sin(2.0 * PI * freq * t) * 0.05  # louder for clarity
			data[i] = Vector2(sample, sample)

		playback.push_buffer(data)
		samples_pushed += chunk_size

		await get_tree().process_frame

# DTMF

func start_dtmf(key: String):
	if not dtmf_table.has(key):
		return

	stop()

	var freqs = dtmf_table[key]
	dtmf_low = freqs.x
	dtmf_high = freqs.y

	dtmf_running = true
	running = false
	phase = 0.0

	play()
	playback = get_stream_playback() as AudioStreamGeneratorPlayback

	generate_dtmf()


func stop_dtmf():
	dtmf_running = false
	stop()


func generate_dtmf():
	while dtmf_running:
		if playback.get_frames_available() >= buffer:
			var data = PackedVector2Array()
			data.resize(buffer)

			for i in range(buffer):
				var sample = (
					sin(2.0 * PI * dtmf_low * phase) * 0.05 +
					sin(2.0 * PI * dtmf_high * phase) * 0.05
				)
				phase += 1.0 / sample_rate
				data[i] = Vector2(sample, sample)

			playback.push_buffer(data)

		await get_tree().process_frame

# DISCONNECT TONE

func start_disconnect_tone():
	stop()
	running = false
	dtmf_running = false
	disconnect_running = true
	phase = 0.0

	play()
	playback = get_stream_playback() as AudioStreamGeneratorPlayback

	generate_disconnect_tone()


func generate_disconnect_tone():
	var freq1 = 480.0
	var freq2 = 620.0

	while disconnect_running:
		var on_samples = int(0.5 * sample_rate)
		var data_on = PackedVector2Array()
		data_on.resize(on_samples)

		for i in range(on_samples):
			var sample = (
				sin(2.0 * PI * freq1 * phase) * 0.05 +
				sin(2.0 * PI * freq2 * phase) * 0.05
			)
			phase += 1.0 / sample_rate
			data_on[i] = Vector2(sample, sample)

		playback.push_buffer(data_on)

		var off_samples = int(0.5 * sample_rate)
		var data_off = PackedVector2Array()
		data_off.resize(off_samples)

		for i in range(off_samples):
			data_off[i] = Vector2(0.0, 0.0)

		playback.push_buffer(data_off)

		await get_tree().process_frame


func stop_disconnect_tone():
	disconnect_running = false
	stop()

# HOWLER

func _process(delta):
	if howler_running and playback:
		howler_timer += delta

		if howler_timer >= HOWLER_INTERVAL:
			howler_timer -= HOWLER_INTERVAL
			howler_on = not howler_on

		if playback.get_frames_available() >= buffer:
			push_howler_chunk(buffer)

func push_howler_chunk(count: int):
	var data = PackedVector2Array()
	data.resize(count)

	for i in range(count):
		var sample := 0.0

		if howler_on:
			for j in range(4):
				sample += sin(howler_phase[j] * TAU)
				howler_phase[j] = fmod(howler_phase[j] + howler_freqs[j] / sample_rate, 1.0)
			sample /= 4.0
			sample *= 0.1  # amplitude
		else:
			sample = 0.0

		data[i] = Vector2(sample, sample)

	playback.push_buffer(data)


func start_howler_tone():
	stop()
	running = false
	dtmf_running = false
	disconnect_running = false

	howler_running = true
	howler_on = true
	howler_timer = 0.0
	howler_phase = [0.0, 0.0, 0.0, 0.0]

	play()
	playback = get_stream_playback() as AudioStreamGeneratorPlayback

func stop_howler_tone():
	howler_running = false
	stop()
	if playback:
		playback.clear_buffer()
	playback = null

#Call

func start_phone_call(dialog_id):
	DialogManager.start_dialog_at(str(dialog_id))
