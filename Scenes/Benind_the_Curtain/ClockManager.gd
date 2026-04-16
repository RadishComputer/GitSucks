#Clock Manager

extends Node

var minutes = 0
var hours = 11
var next_scene_path = ""
var distance_from_church = 0
var chime_sounds = {}
var last_hour_played = -1
var time_pause = false
var time_trigger: String = ""


var time_event = {
	9: "open_gate",
	14: "phone_rings",
	20: "lanterns_light"
}

func _ready():
	call_deferred("connect_knowledge")

	for i in range(1, 13):
		var path = "res://Sounds/church_%d.mp3" % i
		chime_sounds[i] = load(path)
	call_deferred("delayed_clock_update")

func connect_knowledge():
	GameGlue.KnowledgeManager.knowledge_learned.connect(on_knowledge_learned)

func update_chime_volume():
	var bell = get_node_or_null("ChurchBell")
	if bell and bell.playing:
		bell.volume_db = get_distance(distance_from_church)
		print("Updated bell volume to:", bell.volume_db, "based on distance:", distance_from_church)

func delayed_clock_update():
	await get_tree().process_frame
	update_clock_display()

func on_knowledge_learned(id: String):
	if id == time_trigger:
		time_resume(id)


func switch_scene(advance_time = false):
	var previous_hour = int(hours)

	if advance_time and not time_pause:
		minutes += 10
		if minutes >= 60:
			hours += minutes / 60
			minutes = minutes % 60
		hours = hours % 24
		set_front_lamp_default()

	if hours >= 12 and not GameGlue.KnowledgeManager.knows("Met_Dave") and time_trigger == "":
		hours = 12
		minutes = 0
		time_pause = true
		time_trigger = "Met_Dave"

	if hours >= 13 and not GameGlue.KnowledgeManager.knows("Food_Received") and time_trigger == "":
		hours = 13
		minutes = 0
		time_pause = true
		time_trigger = "Food_Received"

	if int(hours) != previous_hour:
		play_church_bell()
		check_time_event()

	if next_scene_path != "":
		GameGlue.load_scene(next_scene_path)
		next_scene_path = ""

	await get_tree().process_frame
	update_clock_display()


func event_trigger(event_name: String):
	match event_name:
		"open_gate":
			print("Gate opens at 9 AM")
# Trigger animation or unlock logic
		"phone_rings":
			print("Phone rings at 2 PM")
# Start dialog or sound
		"lanterns_light":
			print("Lanterns light at 8 PM")
# Change visuals or ambient sound

func check_time_event():
	var current_hour = int(hours) % 24
	if time_event.has(current_hour):
		event_trigger(time_event[current_hour])

func time_resume(trigger_name = ""):
	if time_trigger == "" or time_trigger == trigger_name:
		time_pause = false
		time_trigger = ""
		print("Time resumed due to trigger:", trigger_name)

func update_clock_display():
	var display_hours = hours % 24
	var am_pm = "AM" if display_hours < 12 else "PM"
	var display_hour = display_hours % 12
	if display_hour == 0:
		display_hour = 12
	var time_string = "[center]%02d:%02d %s[/center]" % [display_hour, minutes, am_pm]

	var menu = GameGlue.Menu
	if menu:
		var label = menu.get_node_or_null("Center/Clock")
		if label:
			label.text = time_string
			label.visible = true
			label.queue_redraw()
			print("Clock label updated to:", time_string)
		else:
			print("Clock label not found inside Menu")
	else:
		print("Menu node not found")

func get_distance(distance: int):
	return clamp(-6 * distance, -60, 0)

func play_church_bell():
	var bell = get_node_or_null("ChurchBell")
	if bell:
		var hour = int(hours) % 12
		if hour == 0:
			hour = 12  # Midnight or noon

		var stream = chime_sounds.get(hour, null)
		if stream:
			bell.stream = stream
			bell.volume_db = get_distance(distance_from_church)
			bell.play()

func check_and_play_chime():
	var current_hour = int(hours)
	if last_hour_played == -1:
		last_hour_played = current_hour  # Suppress first chime
		return
	if current_hour != last_hour_played:
		play_church_bell()
		last_hour_played = current_hour

#Time of Day

func get_time_of_day_key() -> String:
	var hour = int(hours) % 24

	for key in time_of_day_styles.keys():
		var start = time_of_day_styles[key]["range"][0]
		var end = time_of_day_styles[key]["range"][1]

		if start <= end:
			if hour >= start and hour <= end:
				return key
		else:
			if hour >= start or hour <= end:
				return key

	return "day" # fallback

func get_time_of_day_tint() -> Color:
	var key = get_time_of_day_key()
	return time_of_day_styles[key]["tint"]

func get_time_of_day_strength() -> float:
	var key = get_time_of_day_key()
	return time_of_day_styles[key]["strength"]


var time_of_day_styles = {
	"morning": {
		"tint": Color(1.0, 0.85, 0.6),
		"strength": 0.4,
		"range": [4, 5]
	},
	"day": {
		"tint": Color(1.0, 1.0, 1.0),
		"strength": 0.0,
		"range": [6, 20]
	},
	"evening": {
		"tint": Color(1.0, 0.85, 0.55),
		"strength": 0.35,
		"range": [21, 22]
	},
	"night": {
		"tint": Color(0.4, 0.5, 1.0),
		"strength": 0.6,
		"range": [23, 3]
	}
}

#Front Room

func front_lamp_default():
	var hour = int(hours)
	return hour >= 22 and hour <= 23

func mom_downstairs():
	var hour = int(hours)
	return hour >= 7 and hour <= 23

func set_front_lamp_default():
	if mom_downstairs():
		if front_lamp_default():
			GameGlue.KnowledgeManager.secretly_learn("Front_Lamp_On")
		else:
			GameGlue.KnowledgeManager.secretly_forget("Front_Lamp_On")

#Street Lights

func street_lights():
	var hour = int(hours)
	return hour >= 22 or hour <= 5
