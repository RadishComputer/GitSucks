#Clock Manager

extends Node2D

signal time_changed(display_string: String)
signal threat_level_midnight

var minutes = 0
var hours = 11
var next_scene_path = ""
var distance_from_church = 0
var chime_sounds = {}
var last_hour_played = -1
var time_pause = false
var time_trigger: String = ""
var phone_return_path: String = ""
var phone_return_advance = false
var midnight_triggered = false

var time_event = {
	9: "open_gate",
	14: "phone_rings",
	20: "lanterns_light"
}

var rodney_schedule = {
	"arcade_am":	[[1100, 1200]],
	"lunch":		[[1200, 1400]],
	"arcade_pm":	[[1400, 1600]],
	"evening":		[[1600, 2100]],
}

var location_schedule = {
	"bucket_flowers": {
		"name": "Bucket Flowers",
		"open_hours": [[800, 1500]],
		"scene_path": "",
		"closed_dialog": "dialog:1739",
		"light_node": "BF_Light"
	},
	"cornicello": {
		"name": "Cornicello",
		"open_hours": [[1100, 2300]],
		"scene_path": "res://Scenes/Shops/Cornicello.tscn",
		"closed_dialog": "dialog:1803",
		"light_node": "C_Light"
	},
	"lolas": {
		"name": "Lola's",
		"open_hours": [[1000, 1800]],
		"scene_path": "res://Scenes/Shops/Lolas.tscn",
		"closed_dialog": "dialog:1802",
		"light_node": "L_Light"
	},
	"monets": {
		"name": "Monet's Coffee",
		"open_hours": [[600, 1800]],
		"scene_path": "",
		"closed_dialog": "dialog:1730",
		"light_node": "M_Light"
	},
	"pins": {
		"name": "Pins",
		"open_hours": [[1100, 2400]],
		"scene_path": "res://Scenes/Pins_Interior/Pins_Desk.tscn",
		"closed_dialog": "dialog:1804",
		"light_node": "P_Light"
	},
	"the_hitching_post": {
		"name": "The Hitching Post",
		"open_hours": [[1200, 2000]],
		"scene_path": "",
		"closed_dialog": "dialog:1801",
		"light_node": "THP_Light"
	},
	"uncle_sams": {
		"name": "Uncle Sam's",
		"open_hours": [[1000, 2400], [0,100]],
		"scene_path": "res://Scenes/Shops/Uncle_Sams.tscn",
		"closed_dialog": "dialog:1801",
		"light_node": "US_Light"
	},
}

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

func _ready():
	call_deferred("connect_knowledge")

	for i in range(1, 13):
		var path = "res://Sounds/church_%d.wav" % i
		chime_sounds[i] = load(path)
	call_deferred("delayed_clock_update")

	threat_level_midnight.connect(at_midnight)

func connect_knowledge():
	GameGlue.KnowledgeManager.knowledge_learned.connect(on_knowledge_learned)

func delayed_clock_update():
	await get_tree().process_frame
	update_clock_display()

#Time and Space

func switch_scene(advance_time = false):
	print("ClockManager.switch_scene called - next_scene_path = ", next_scene_path)
	var previous_hour = int(hours)

	if advance_time and not time_pause:
		minutes += 10
		if minutes >= 60:
			hours += minutes/  60
			minutes = minutes % 60
		hours = hours % 24
		set_front_lamp_default()

	if hours >= 12 and not GameGlue.KnowledgeManager.knows("Met_Dave") and time_trigger == "":
		hours = 12
		minutes = 0
		time_pause = true
		time_trigger = "Met_Dave"

	if hours >= 13 and not GameGlue.KnowledgeManager.secretly_knows("Food_Received") and time_trigger == "":
		hours = 13
		minutes = 0
		time_pause = true
		time_trigger = "Food_Received"

	if hours == 24 and minutes == 0:
		midnight_triggered = true
		emit_signal("threat_level_midnight")

	if int(hours) != previous_hour:
		church_bell()
		check_time_event()

	if next_scene_path != "":
		GameGlue.load_scene(next_scene_path)
		next_scene_path = ""

	await get_tree().process_frame
	update_clock_display()

func time_resume(trigger_name = ""):
	if time_trigger == "" or time_trigger == trigger_name:
		time_pause = false
		time_trigger = ""
		print("Time resumed due to trigger:", trigger_name)

func on_knowledge_learned(id: String):
	if id == time_trigger:
		time_resume(id)

func location_open(location_id: String):
	if not location_schedule.has(location_id):
		return false
	var current_time = (int(hours) * 100) + int(minutes)
	var time_ranges = location_schedule[location_id].get("open_hours", [])
	for r in time_ranges:
		var start = r[0]
		var end = r[1]
		if current_time >= start and current_time < end:
			return true
	return false

func try_to_enter(location_id: String, caller_scene: Node, advance_time: bool = false):
	if not location_schedule.has(location_id):
		print("ClockManager: Unknown business ID: ", location_id)
		return
	var info = location_schedule[location_id]
	var open = location_open(location_id)
	if open and info.get("scene_path", "") != "":
		next_scene_path = info["scene_path"]
		switch_scene(advance_time)
	else:
		var dialog_id = info.get("closed_dialog", "")
		if dialog_id != "":
			GameGlue.SequenceMachine.run_sequence([dialog_id], caller_scene)

func go_to_phone(return_path: String, advance_time = false):
	print("GOING TO PHONE. RETURN =", return_path)
	print("Phone booth file exists =", FileAccess.file_exists("res://Scenes/Zone_Another/Phone_Booth.tscn"))
	phone_return_path = return_path
	phone_return_advance = advance_time
	next_scene_path = "res://Scenes/Zone_Another/Phone_Booth.tscn"
	switch_scene(false)

#Events and Sounds

func check_time_event():
	var current_hour = int(hours) % 24
	if time_event.has(current_hour):
		event_trigger(time_event[current_hour])

func event_trigger(event_name: String):
	match event_name:
		"open_gate":
			print("Gate opens at 9 AM")
		"phone_rings":
			print("Phone rings at 2 PM")
		"lanterns_light":
			print("Lanterns light at 8 PM")

func church_bell():
	var current_hour = int(hours)
	if last_hour_played == -1:
		last_hour_played = current_hour  #Suppress First Chime
		return

	if current_hour == last_hour_played:
		return

	last_hour_played = current_hour
	var bell = get_node_or_null("ChurchBell")
	if bell:
		var chime_hour = int(hours) % 12
		if chime_hour == 0:
			chime_hour = 12  #Midnight or Noon

		var stream = chime_sounds.get(chime_hour, null)
		if stream:
			bell.stream = stream
			bell.volume_db = get_distance(distance_from_church)
			bell.play()

func update_chime_volume():
	var bell = get_node_or_null("ChurchBell")
	if bell and bell.playing:
		bell.volume_db = get_distance(distance_from_church)
		print("Updated bell volume to:", bell.volume_db, "based on distance:", distance_from_church)

func get_distance(distance: int):
	return clamp(-6 * distance, -60, 0)

#Visuals

func update_clock_display():
	var display_hours = hours % 24
	var am_pm = "AM" if display_hours < 12 else "PM"
	var display_hour = display_hours % 12
	if display_hour == 0:
		display_hour = 12
	var time_string = "[center]%02d:%02d %s[/center]" % [display_hour, minutes, am_pm]

	time_changed.emit(time_string)

	var menu = GameGlue.Menu
	if menu:
		var label = menu.get_node_or_null("Center/Clock")
		if label:
			label.text = time_string
			label.visible = true
			label.queue_redraw()

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

	return "day" #Fallback

func get_time_of_day_tint() -> Color:
	var key = get_time_of_day_key()
	return time_of_day_styles[key]["tint"]

func get_time_of_day_strength() -> float:
	var key = get_time_of_day_key()
	return time_of_day_styles[key]["strength"]

func update_lights(scene_node: Node):
	if not scene_node:
		return

	if scene_node.has_node("Time_of_Day"):
		var tod_node = scene_node.get_node("Time_of_Day")
		if tod_node and tod_node.material:
			tod_node.material.set_shader_parameter("tint_color", get_time_of_day_tint())
			tod_node.material.set_shader_parameter("strength", get_time_of_day_strength())

	var street_on = street_lights()
	for street_node_name in ["Street_Light"]:
		if scene_node.has_node(street_node_name):
			var s_node = scene_node.get_node(street_node_name)
			if s_node and s_node.material:
				s_node.material.set_shader_parameter("light_enabled", street_on)

	if scene_node.has_node("Upstairs_Lamp"):
		var light_node = scene_node.get_node("Upstairs_Lamp")
		if light_node and light_node.material:
			var enabled = GameGlue.KnowledgeManager.secretly_knows("Upstairs_Lamp_On")
			light_node.material.set_shader_parameter("light_enabled", enabled)

	if scene_node.has_node("Front_Light"):
		var light_node = scene_node.get_node("Front_Light")
		if light_node and light_node.material:
			var enabled = GameGlue.KnowledgeManager.secretly_knows("Front_Lamp_On")
			light_node.material.set_shader_parameter("light_enabled", enabled)

	if scene_node.has_node("House_Light"):
		var light_node = scene_node.get_node("House_Light")
		if light_node and light_node.material:
			var hour = int(hours)
			var enabled = (hour >= 22 and hour < 24)
			light_node.material.set_shader_parameter("light_enabled", enabled)

	for location_id in location_schedule.keys():
		var info = location_schedule[location_id]
		var light_node_name = info.get("light_node", "")
		if light_node_name != "" and scene_node.has_node(light_node_name):
			var light_node = scene_node.get_node(light_node_name)
			var enabled = location_open(location_id)
			if light_node and light_node.material:
				light_node.material.set_shader_parameter("light_enabled", enabled)

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

#Rodney

func rodney_here(location: String):
	var current_time = (int(hours) * 100) + int(minutes)
	if not rodney_schedule.has(location):
		return false

	var data = rodney_schedule[location]
	if data.size() > 0 and typeof(data[0]) != TYPE_ARRAY:
		return current_time >= data[0] and current_time < data[1]

	for time_range in data:
		if current_time >= time_range[0] and current_time < time_range [1]:
			return true
	return false

#Sammy

func wheres_sammy():
	var hour = int(hours)
	return hour >= 11 and hour <= 13

#Jeff

func wheres_jeff():
	var hour = int(hours)
	return hour >= 12 and hour <= 16

#Day One Kids

func day_one_kids():
	var hour = int(hours)
	return hour >= 10 and hour <= 17

#Streets

func street_lights():
	var hour = int(hours)
	return hour >= 22 or hour <= 5

#End of Day

func at_midnight():
	GameGlue.SequenceMachine.run_sequence([
			"dialog:1981",
			"action:fade_to_black",
			"action:switch_scene:res://Scenes/Winter_House/Bear_Room.tscn",
			"action:snap_back",
		], self)

#Export

func export_state():
	return {
		"hours": hours,
		"minutes": minutes,
	}

func import_state(data):
	hours = int(data.get("hours", 0))
	minutes = int(data.get("minutes", 0))
