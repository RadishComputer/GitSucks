#TextBox

extends Control

signal dialog_advanced

enum Text_Mode {NONE, DIALOG, CHOICE, NOTE}

@onready var dialog_panel = $DialogBox
@onready var dialog_label = $DialogBox/Dialog
@onready var note_panel = $NoteBox
@onready var note_label = $NoteBox/Center/Note
@onready var front_blocker = $Front_Blocker
@onready var back_blocker = $Back_Blocker
@onready var arrow = $DialogBox/Arrow
@onready var choices_container = $DialogBox/Choices
@onready var current_highlighted_button: Button = null 
@onready var choice_arrow = $DialogBox/Choice_Arrow
@onready var speaker_label = $DialogBox/Center/Speaker
@onready var note_sound = $Note
@onready var type_sound = $Type
@onready var shop_panel = $ShopBox
@onready var shop_speaker_label = $ShopBox/Center/Speaker
@onready var shop_label = $ShopBox/Dialog
@onready var shop_choices = $ShopBox/Choices
@onready var shop_choice_arrow = $ShopBox/Choice_Arrow
@onready var intro_panel = $IntroBox
@onready var intro_label = $IntroBox/Dialog

var speaker_sounds = {
	"Summer": preload("res://Sounds/Duh.wav"),
	"Mom": preload("res://Sounds/Eh.wav"),
	"Wes": preload("res://Sounds/Twang.wav"),
	"Jessica": preload("res://Sounds/Tap.wav"),
	"Jimmy": preload("res://Sounds/Bubby.wav"),
	"Roberta": preload("res://Sounds/Kick.wav"),
	"Evie": preload("res://Sounds/Buzz.wav"),
	"Dave": preload("res://Sounds/Oh.wav"),
	"Sammy": preload("res://Sounds/Squawk.wav"),
	"Max": preload("res://Sounds/Piano.wav"),
	"Gina": preload("res://Sounds/Fizz.wav"),
	"Perla": preload("res://Sounds/Harp.wav"),
	"Maria": preload("res://Sounds/Bong.wav"),
} 

var note_sounds = {
	"default": preload("res://Sounds/Note.wav"),
	"save": preload("res://Sounds/Save.wav"),
	"none": null,
}

var default_type_sound = preload("res://Sounds/Beep.wav") #Beep

var letter_pitches = {
	"a": 1.00,
	"b": 1.05,
	"c": 0.95,
	"d": 1.10,
	"e": 1.02,
	"f": 0.98,
	"g": 1.07,
	"h": 1.03,
	"i": 1.12,
	"j": 0.93,
	"k": 1.15,
	"l": 1.08,
	"m": 0.97,
	"n": 1.04,
	"o": 1.01,
	"p": 1.06,
	"q": 0.92,
	"r": 1.09,
	"s": 1.00,
	"t": 1.11,
	"u": 1.03,
	"v": 0.96,
	"w": 1.14,
	"x": 0.94,
	"y": 1.13,
	"z": 0.91,
}

var use_shop_skin = false
var use_intro_skin = false

var active_panel: Control
var active_label: RichTextLabel
var active_speaker_label: RichTextLabel
var active_choices_container: Control
var active_choice_arrow: Label


var is_typing = false
var skip_typewriter = false
var waiting_for_input = false
var note_callback: Callable = Callable()
var last_hovered_button: Button = null
var current_mode: Text_Mode = Text_Mode.NONE

var char_times = []
var original_text: String = ""
var displayed_text: String = ""

var start_time = Time.get_ticks_msec() / 1000.0

func _ready():
	await get_tree().process_frame
	print("DialogPanel =", dialog_panel)

	var current_highlighted_button: Button = null
	var choice_arrow = $DialogBox/Choice_Arrow
	var last_hovered_button: Button = null

func _process(_delta: float):
	if active_choices_container == null:
		return

	if not active_choice_arrow or not is_instance_valid(active_choice_arrow):
		if use_shop_skin:
			active_choice_arrow = shop_choice_arrow
		else:
			active_choice_arrow = choice_arrow

	if not active_choices_container.visible or active_choices_container.get_child_count() == 0:
		if last_hovered_button:
			unhighlight_choice(last_hovered_button)
			last_hovered_button = null
		return

	var mouse_pos = get_viewport().get_mouse_position()
	var new_hovered: Button = null

	for child in active_choices_container.get_children():
		if child is Button and child.get_global_rect().has_point(mouse_pos):
			new_hovered = child
			break

	if new_hovered != last_hovered_button:
		if last_hovered_button:
			unhighlight_choice(last_hovered_button)

		if new_hovered:
			highlight_choice(new_hovered)

		last_hovered_button = new_hovered

func apply_theme(theme_name: String):
	var theme_path = "res://Elements/theme_%s.tres" % theme_name
	var new_theme = load(theme_path)
	
	if new_theme:
		self.theme = new_theme

func enter_mode(new_mode: Text_Mode):
	hide_everything()
	current_mode = new_mode

	match new_mode:
		Text_Mode.DIALOG:
			active_panel.visible = true
			front_blocker.visible = true
			back_blocker.visible = true
		Text_Mode.CHOICE:
			active_choices_container.visible = true
			active_panel.visible = true
			back_blocker.visible = true
		Text_Mode.NOTE:
			note_panel.visible = true
			front_blocker.visible = true
			back_blocker.visible = true
		Text_Mode.NONE:
			front_blocker.visible = false
			back_blocker.visible = false

func hide_everything():
	dialog_panel.visible = false
	shop_panel.visible = false
	note_panel.visible = false
	intro_panel.visible = false
	choices_container.visible = false
	shop_choices.visible = false
	arrow.visible = false
	front_blocker.visible = false
	back_blocker.visible = false
	is_typing = false
	skip_typewriter = false
	waiting_for_input = false
	current_highlighted_button = null
	last_hovered_button = null

func set_skin(skin_type):
	var is_shop = false
	var is_intro = false

	if typeof(skin_type) == TYPE_BOOL:
		is_shop = skin_type
	elif typeof(skin_type) == TYPE_STRING:
		is_shop = (skin_type == "shop")
		is_intro = (skin_type == "intro")

	use_shop_skin = is_shop
	use_intro_skin = is_intro

	if use_intro_skin:
		active_panel = intro_panel
		active_label = intro_label
		active_speaker_label = null
		active_choices_container = null
		active_choice_arrow = null
	elif use_shop_skin:
		active_panel = shop_panel
		active_label = shop_label
		active_speaker_label = shop_speaker_label
		active_choices_container = shop_choices
		active_choice_arrow = shop_choice_arrow
	else:
		active_panel = dialog_panel
		active_label = dialog_label
		active_speaker_label = speaker_label
		active_choices_container = choices_container
		active_choice_arrow = choice_arrow

#Dialog

func show_dialog_text(text: String, speaker: String = ""):
	enter_mode(Text_Mode.DIALOG)
	char_times.clear()
	start_time = Time.get_ticks_msec() / 1000.0

	if active_speaker_label:
		active_speaker_label.text = speaker
		if speaker == "Summer":
			active_label.add_theme_color_override("default_color", Color("#FEA9AC"))
			active_speaker_label.add_theme_color_override("default_color", Color("#FEA9AC"))
			arrow.add_theme_color_override("font_color", Color("#FEA9AC"))
		else:
			active_label.remove_theme_color_override("default_color")
			active_speaker_label.remove_theme_color_override("default_color")
			arrow.remove_theme_color_override("font_color")
	else:
		active_label.remove_theme_color_override("default_color")

	if speaker_sounds.has(speaker):
		type_sound.stream = speaker_sounds[speaker]
	else:
		type_sound.stream = default_type_sound

	var wrap_width = get_wrap_width()
	var wrapped = wrap_text_simple(text, wrap_width)
	original_text = wrapped

	await typewriter(wrapped)

	waiting_for_input = true
	if active_choices_container and not active_choices_container.visible:
		arrow.visible = true
	elif not active_choices_container:
		arrow.visible = false

func get_wrap_width() -> int:
	if use_intro_skin:
		match GameGlue.SettingsManager.text_size:
			"S":
				return 100
			"M":
				return 90
			"L":
				return 70
			_:
				return 90
	elif use_shop_skin:
		match GameGlue.SettingsManager.text_size:
			"S":
				return 50
			"M":
				return 44
			"L":
				return 33
			_:
				return 70
	else:
		match GameGlue.SettingsManager.text_size:
			"S":
				return 100
			"M":
				return 90
			"L":
				return 70
			_:
				return 90

func typewriter(text: String):
	is_typing = true
	skip_typewriter = false

	var delay = 0.02
	if active_speaker_label and active_speaker_label.text == "Skip the Radio Ghost":
		delay = 0.08
	
	var i = 0
	var current_text = ""

	while i < text.length():
		if skip_typewriter or not is_typing:
			break

		current_text += text[i]
		displayed_text = current_text

		if i % 2 == 0 and text[i] != " " and text[i] != ".":
			var c = text[i].to_lower()
			if letter_pitches.has(c):
				type_sound.pitch_scale = letter_pitches[c]
			else:
				type_sound.pitch_scale = 1.0
			type_sound.play()

		if GameGlue.SettingsManager.bounce_mode:
			char_times.append(Time.get_ticks_msec() / 1000.0)

			var bbcode = ""
			for char_idx in range(current_text.length()):
				var c: String = current_text[char_idx]

				if c == " ":
					bbcode += " "
					continue

				var start_time = char_times[char_idx] if char_idx < char_times.size() else Time.get_ticks_msec() / 1000.0

				bbcode += "[bounce start_time=%s]%s[/bounce]" % [
					str(start_time),
					c
				]

			active_label.parse_bbcode(bbcode)
		else:
			active_label.text = current_text

		i += 1
		await get_tree().create_timer(delay).timeout
		if skip_typewriter or not is_typing:
			break

	is_typing = false

func wrap_text_simple(text: String, max_chars_per_line: int) -> String:
	var lines = text.split("\n")
	var result = ""

	for raw_line in lines:
		var words = raw_line.split(" ")
		var line = ""

		for w in words:
			if line.length() + w.length() + 1 > max_chars_per_line:
				result += line.strip_edges() + "\n"
				line = ""
			line += w + " "

		result += line.strip_edges() + "\n"

	return result.strip_edges()

func hide_dialog():
	enter_mode(Text_Mode.NONE)

#Choice

func show_choice_buttons(choice_map: Dictionary):
	arrow.visible = false
	active_choices_container.visible = true
	back_blocker.visible = true
	front_blocker.visible = false
	waiting_for_input = false

	for child in active_choices_container.get_children():
		if child != active_choice_arrow:
			child.queue_free()

	current_highlighted_button = null
	last_hovered_button = null

	if active_choice_arrow and is_instance_valid(active_choice_arrow):
		active_choice_arrow.visible = false
		active_choice_arrow.reparent(active_choices_container)
	else:
		if use_shop_skin:
			active_choice_arrow = $ShopBox/Choice_Arrow
		else:
			active_choice_arrow = $DialogBox/Choice_Arrow

	for label in choice_map.keys():
		var b = Button.new()
		b.text = label

		var empty = StyleBoxEmpty.new()
		b.add_theme_stylebox_override("normal", empty)
		b.add_theme_stylebox_override("hover", empty)
		b.add_theme_stylebox_override("pressed", empty)
		b.add_theme_stylebox_override("focus", empty)

		var invisible_hover = StyleBoxFlat.new()
		invisible_hover.bg_color = Color(1, 1, 1, 0.1)
		b.add_theme_stylebox_override("hover", invisible_hover)

		b.alignment = HORIZONTAL_ALIGNMENT_LEFT
		b.focus_mode = Control.FOCUS_ALL

		b.focus_entered.connect(highlight_choice.bind(b))
		b.focus_exited.connect(unhighlight_choice.bind(b))

		b.pressed.connect(choice_map[label])
		active_choices_container.add_child(b)

		b.update_minimum_size()
		await get_tree().process_frame

	var first_button: Button = null

	for child in active_choices_container.get_children():
		if child is Button:
			first_button = child
			break

	if first_button:
		await get_tree().process_frame
		first_button.grab_focus()
		highlight_choice(first_button)


func update_choice_fonts(): 
	var dialog_font = dialog_label.get_theme_font("font")
	var dialog_size = dialog_label.get_theme_font_size("font")

	for child in active_choices_container.get_children():
		if child is Button:
			child.add_theme_font_override("font", dialog_label.get_theme_font("font"))
			child.add_theme_font_size_override("font_size", dialog_label.get_theme_font_size("font"))

func highlight_choice(button: Button):
	if not active_choice_arrow or not is_instance_valid(active_choice_arrow):
		active_choice_arrow = $DialogBox/Choice_Arrow 
		if not active_choice_arrow or not is_instance_valid(active_choice_arrow):
			return
			
	if current_highlighted_button and current_highlighted_button != button:
		active_choice_arrow.visible = false

	if active_choice_arrow.get_parent() != button:
		active_choice_arrow.reparent(button)

	var font_size = button.get_theme_font_size("font")

	var offset_x = -(font_size * 2.1)
	var y_center = button.size.y / 2 - active_choice_arrow.size.y / 2

	active_choice_arrow.position = Vector2(offset_x, y_center)
	active_choice_arrow.visible = true
	current_highlighted_button = button


func unhighlight_choice(button: Button):
	if not active_choice_arrow or not is_instance_valid(active_choice_arrow):
		return

	if current_highlighted_button == button:
		active_choice_arrow.visible = false
		current_highlighted_button = null

#Notes

func show_note(text: String, callback: Callable = Callable(), sound_key: String = "default"):
	var custom_sound = null

	if note_sounds.has(sound_key):
		custom_sound = note_sounds[sound_key]

	if custom_sound != null:
		note_sound.stream = custom_sound
		note_sound.play()

	enter_mode(Text_Mode.NOTE)
	note_label.clear()
	await get_tree().process_frame
	note_label.append_text("[center]" + text + "[/center]")
	note_callback = callback

func hide_note():
	enter_mode(Text_Mode.NONE)
	if note_callback.is_valid():
		note_callback.call()
		note_callback = Callable()

#Input

func front_blocker_click(event):
	if not event is InputEventMouseButton or event.pressed:
		return
		
	match current_mode:
		Text_Mode.DIALOG:
			var can_skip = active_speaker_label == null or active_speaker_label.text != "Skip the Radio Ghost"
			if is_typing:
				if can_skip:
					skip_typewriter = true
					is_typing = false
					waiting_for_input = true
					if GameGlue.SettingsManager.bounce_mode:
						char_times.clear()
						for j in range(original_text.length()):
							char_times.append(Time.get_ticks_msec() / 1000.0)

						var full_bbcode = ""
						for j in range(original_text.length()):
							var c: String = original_text[j]
							if c == " ":
								full_bbcode += " "
							else:
								var start_time = char_times[j]
								full_bbcode += "[bounce start_time=%s]%s[/bounce]" % [
									str(start_time),
									c
								]
						active_label.parse_bbcode(full_bbcode)
					else:
						active_label.text = original_text
						
					if active_choices_container and not active_choices_container.visible:
						arrow.visible = true
			elif waiting_for_input:
				waiting_for_input = false
				if use_intro_skin:
					hide_dialog()
					dialog_advanced.emit()
				GameGlue.DialogManager.advance_dialog()

		Text_Mode.NOTE:
			hide_note()
