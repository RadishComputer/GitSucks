extends AudioStreamPlayer

var generator = AudioStreamGenerator.new()
var playback: AudioStreamGeneratorPlayback

var running = false
var dtmf_running = false
var disconnect_running = false
var howler_running = false
var ring_running = false

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
	"Pound": Vector2(941.0, 1477.0),
}

func _ready():
	generator.mix_rate = sample_rate
	stream = generator

func stop_all():
	running = false
	dtmf_running = false
	disconnect_running = false
	howler_running = false
	ring_running = false
	stop()
	if playback:
		playback.clear_buffer()
	playback = null
	phase = 0.0

#Dial Tone
 
func play_dial_tone():
	if running:
		return
	stop_all()
	running = true
	play()
	playback = get_stream_playback() as AudioStreamGeneratorPlayback
	generate_dial_tone()

func stop_dial_tone():
	running = false
	stop_all()

func generate_dial_tone():
	while running and playback:
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

#SIT Tone

func generate_sit_tone():
	stop_all()
	play()
	playback = get_stream_playback() as AudioStreamGeneratorPlayback
	await get_tree().process_frame

	await play_sit_tone(913.8, 0.274)
	await play_sit_tone(1370.6, 0.274)
	await play_sit_tone(1776.7, 0.380)

	await get_tree().create_timer(0.8).timeout
	stop_all()


func play_sit_tone(freq: float, duration: float):
	var total_samples = int(duration * sample_rate)
	var samples_pushed = 0
	var chunk_size = 1024

	while samples_pushed < total_samples and playback:
		while playback and playback.get_frames_available() < chunk_size:
			await get_tree().process_frame
		if not playback:
			return

		var data = PackedVector2Array()
		data.resize(chunk_size)
		for i in range(chunk_size):
			var t = float(samples_pushed + i) / sample_rate
			var sample = sin(2.0 * PI * freq * t) * 0.05
			data[i] = Vector2(sample, sample)

		playback.push_buffer(data)
		samples_pushed += chunk_size
		await get_tree().process_frame

#DTMF

func start_dtmf(key: String):
	if not dtmf_table.has(key):
		return
	stop_all()
	var freqs = dtmf_table[key]
	dtmf_low = freqs.x
	dtmf_high = freqs.y
	dtmf_running = true
	play()
	playback = get_stream_playback() as AudioStreamGeneratorPlayback
	generate_dtmf()

func stop_dtmf():
	dtmf_running = false
	stop_all()

func generate_dtmf():
	while dtmf_running and playback:
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

#Disconnect

func start_disconnect_tone():
	stop_all()
	disconnect_running = true
	play()
	playback = get_stream_playback() as AudioStreamGeneratorPlayback
	generate_disconnect_tone()

func stop_disconnect_tone():
	disconnect_running = false
	stop_all()

func generate_disconnect_tone():
	var freq1 = 480.0
	var freq2 = 620.0
	while disconnect_running and playback:
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
		if playback:
			playback.push_buffer(data_on)

		var off_samples = int(0.5 * sample_rate)
		var data_off = PackedVector2Array()
		data_off.resize(off_samples)
		data_off.fill(Vector2.ZERO)
		if playback:
			playback.push_buffer(data_off)

		await get_tree().process_frame

#Howler

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
			sample = (sample / 4.0) * 0.01
		data[i] = Vector2(sample, sample)
	playback.push_buffer(data)


func start_howler_tone():
	stop_all()
	howler_running = true
	howler_on = true
	howler_timer = 0.0
	howler_phase = [0.0, 0.0, 0.0, 0.0]
	play()
	playback = get_stream_playback() as AudioStreamGeneratorPlayback


func stop_howler_tone():
	howler_running = false
	stop_all()

#Ring Tone

func start_ring_tone():
	stop_all()
	ring_running = true
	play()
	playback = get_stream_playback() as AudioStreamGeneratorPlayback
	generate_ring_tone()

func stop_ring_tone():
	ring_running = false
	stop_all()

func generate_ring_tone():
	var freq1 = 440.0
	var freq2 = 480.0
	var chunk = 2048

	while ring_running and playback:
		var on_samples = int(2.0 * sample_rate)
		var data_on = PackedVector2Array()
		data_on.resize(on_samples)
		for i in range(on_samples):
			var sample = (
				sin(2.0 * PI * freq1 * phase) * 0.05 +
				sin(2.0 * PI * freq2 * phase) * 0.05
			)
			phase += 1.0 / sample_rate
			data_on[i] = Vector2(sample, sample)

		var pushed = 0
		while pushed < on_samples and ring_running and playback:
			var size = mini(chunk, on_samples - pushed)
			var slice = data_on.slice(pushed, pushed + size)
			while ring_running and playback and playback.get_frames_available() < size:
				await get_tree().process_frame
			if not (ring_running and playback):
				return
			playback.push_buffer(slice)
			pushed += size
			await get_tree().process_frame

		if not (ring_running and playback):
			return

		var off_samples = int(4.0 * sample_rate)
		var data_off = PackedVector2Array()
		data_off.resize(off_samples)
		data_off.fill(Vector2.ZERO)

		pushed = 0
		while pushed < off_samples and ring_running and playback:
			var size = mini(chunk, off_samples - pushed)
			var slice = data_off.slice(pushed, pushed + size)
			while ring_running and playback and playback.get_frames_available() < size:
				await get_tree().process_frame
			if not (ring_running and playback):
				return
			playback.push_buffer(slice)
			pushed += size
			await get_tree().process_frame

#Call

func start_phone_call(dialog_id):
	start_ring_tone()
	await get_tree().create_timer(7.0).timeout
	stop_ring_tone()
	GameGlue.DialogManager.start_dialog_at(str(dialog_id))
