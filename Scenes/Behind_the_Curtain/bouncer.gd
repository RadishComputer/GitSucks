extends Node

var active_bounces = {}
var original_y = {}
var bounce_duration = 0.35
var bounce_amplitude = 20.0
var bounce_phase_speed = 10.0
var bounce_decay_power = 2.2

func _process(_delta):
	if not GameGlue.SettingsManager.bounce_mode:
		return

	var now = Time.get_ticks_msec() / 1000.0

	for button in active_bounces.keys():
		if not is_instance_valid(button):
			active_bounces.erase(button)
			continue

		var start_time = active_bounces[button]
		var time = now - start_time

		if time > bounce_duration:
			active_bounces.erase(button)
			button.position.y = original_y[button]
			continue

		var progress = time / bounce_duration
		var decay = pow(1.0 - progress, bounce_decay_power)
		var phase = time * bounce_phase_speed

		var offset = -sin(phase) * decay * bounce_amplitude
		button.position.y = original_y[button] + offset


func register_button(button: TextureButton):
	if not original_y.has(button):
		original_y[button] = button.position.y


func bounce(button: TextureButton):
	if not GameGlue.SettingsManager.bounce_mode:
		return

	register_button(button)
	active_bounces[button] = Time.get_ticks_msec() / 1000.0
