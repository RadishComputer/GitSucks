#Bear Room Phone

extends Control

var current_number = ""
var last_key_release_time = 0
var last_activity_time = 0
var after_sit_played = 0
var waiting_for_disconnect = false
var howler_started = false
var phone_locked = false
const SHORT_CODES = ["911", "0"]
const FULL_LENGTH = 5

var sit_playing = false
var number_check_delay = 0.9
var howler_delay = 5.0
var waiting_for_howler = false


func _ready():
	ClockManager.distance_from_church = 8
	ClockManager.update_chime_volume()
	ClockManager.update_clock_display()
	await get_tree().process_frame
	ClockManager.check_and_play_chime()
	update_time_of_day_shader()
	update_light_shader()
	play_dial_tone()

	$Back.input_event.connect(on_exit.bind("res://Scenes/Bear_Room.tscn", true))

	$Key1.input_event.connect(on_button_input.bind("Key1"))
	$Key2.input_event.connect(on_button_input.bind("Key2"))
	$Key3.input_event.connect(on_button_input.bind("Key3"))
	$Key4.input_event.connect(on_button_input.bind("Key4"))
	$Key5.input_event.connect(on_button_input.bind("Key5"))
	$Key6.input_event.connect(on_button_input.bind("Key6"))
	$Key7.input_event.connect(on_button_input.bind("Key7"))
	$Key8.input_event.connect(on_button_input.bind("Key8"))
	$Key9.input_event.connect(on_button_input.bind("Key9"))
	$Key0.input_event.connect(on_button_input.bind("Key0"))
	$Star.input_event.connect(on_button_input.bind("Star"))
	$Pound.input_event.connect(on_button_input.bind("Pound"))
	$Hook.input_event.connect(on_hook_input)

func _process(delta):
	var now = Time.get_ticks_msec() / 1000.0


	if current_number.length() >= 3 and not phone_locked and not sit_playing:
		if now - last_key_release_time >= number_check_delay:
			try_process_number()

	# SIT finished
	if waiting_for_howler:
		if now >= after_sit_played + howler_delay:
			waiting_for_howler = false
			stop_all_audio()
			PhoneAudio.start_howler_tone()

	# Idle timeout
	if current_number == "" and not phone_locked and not sit_playing:
		if now - last_activity_time > 5.0:
			stop_all_audio()
			PhoneAudio.start_howler_tone()

func on_exit(viewport, event, shape_idx, scene_path: String, advance_time: bool):
	if InputManager.click_release(event):
		stop_all_audio()
		ClockManager.next_scene_path = scene_path
		if advance_time:
			ClockManager.switch_scene(true)
		else:
			get_tree().change_scene_to_file(scene_path)
		print("Going to %s" % scene_path)

#Day Lighting

func update_time_of_day_shader():
	var tint = ClockManager.get_time_of_day_tint()
	var strength = ClockManager.get_time_of_day_strength()

	$Time_of_Day.material.set_shader_parameter("tint_color", tint)
	$Time_of_Day.material.set_shader_parameter("strength", strength)

#Lamp Lighting

func update_light_shader():
	var enabled = KnowledgeManager.secretly_knows("Lamp_On")
	$Lamp_Light.material.set_shader_parameter("light_enabled", enabled)

#Phone

func play_dial_tone():
	PhoneAudio.play_dial_tone()
	last_activity_time = Time.get_ticks_msec()

func stop_all_audio():
	PhoneAudio.stop_howler_tone()
	PhoneAudio.stop_dtmf()
	PhoneAudio.stop_dial_tone()

func play_SIT():
	await PhoneAudio.generate_sit_tone()
	sit_playing = false

func play_key_sound(digit: String):
	PhoneAudio.play_dtmf(digit)

func key_pressed(key_name: String):
	PhoneAudio.stop_dial_tone()
	PhoneAudio.start_dtmf(key_name)
	last_activity_time = Time.get_ticks_msec()

func key_released(key: String):
	PhoneAudio.stop_dtmf()
	last_key_release_time = Time.get_ticks_msec() / 1000.0
	last_activity_time = Time.get_ticks_msec()

	if current_number == "":
		play_dial_tone()

#Key

func on_button_input(viewport, event, shape_idx, key_name: String):
	if phone_locked:
		return
	if event is InputEventMouseButton:
		if event.pressed:
			var digit = ""

			if key_name.begins_with("Key"):
				digit = key_name.substr(3, 1)
			elif key_name == "Star":
				digit = "*"
			elif key_name == "Pound":
				digit = "#"

			key_pressed(key_name)
			dialed_digit(digit)

		else:
			key_released(key_name)

#Hook

func on_hook_input(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.pressed:
			hook_pressed()
		else:
			hook_released()

func hook_pressed():
	stop_all_audio()
	current_number = ""
	sit_playing = false
	waiting_for_howler = false

func hook_released():
	stop_all_audio()
	current_number = ""
	phone_locked = false
	play_dial_tone()

func dialed_digit(digit: String):
	current_number += digit

func try_process_number():
	if phone_locked:
		return

	var number = current_number

	if number in SHORT_CODES:
		process_number(number)
		return

	if number.length() != FULL_LENGTH:
		return

	process_number(number)

func process_number(number: String):
	phone_locked = true
	PhoneAudio.stop_dtmf()
	PhoneAudio.stop_dial_tone()

	var result = PhoneBook.lookup(number)

	match result.type:

		"call":
			await trigger_call(result.steps)

		"event":
			await trigger_event(result.event)

		"invalid":
			await play_SIT()
			sit_playing = true
			after_sit_played = Time.get_ticks_msec() / 1000.0
			waiting_for_howler = true

func trigger_call(steps: Array):
	stop_all_audio()
	phone_locked = true
	current_number = ""

	SequenceMachine.run_sequence(steps, self)

	# Wait until the sequence finishes
	while SequenceMachine.running:
		await get_tree().process_frame #Error happened here

	phone_locked = false
	after_sit_played = Time.get_ticks_msec() / 1000.0
	waiting_for_howler = true

func trigger_event(event_name: String):
	stop_all_audio()
	phone_locked = true

	match event_name:
		"unlock_basement":
			KnowledgeManager.learn("Basement_Unlocked")


		"acoustic_coupler":
			await PhoneAudio.play_coupler_sequence()

		_:
			print("Unknown phone event:", event_name)

	phone_locked = false
	current_number = ""
	play_dial_tone()

func save_game():
	print("Game saved (placeholder)")
	TextBox.enter_mode(TextBox.Text_Mode.DIALOG)
	DialogManager.advance_dialog()
