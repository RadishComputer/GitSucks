extends Control

@onready var perception = $Mask/Perception
@onready var dialog_portrait = $Mask/Dialog_Portrait
@onready var shop_portrait = $Mask/Shop_Portrait

var current_portrait = ""
var current_perception = ""
var current_target_portrait: TextureRect = null

var portraits = {
	"mom_d": preload("res://Art/Beta/Characters/Susan.png"),
	"wes_d": preload("res://Art/Beta/Characters/Wes.png"),
	"jessica_d": preload("res://Art/Beta/Characters/Jessica.png"),
	"jimmy_d": preload("res://Art/Beta/Characters/Jimmy.png"),
	"roberta_d": preload("res://Art/Beta/Characters/Roberta.png"),
	"evie_d": preload("res://Art/Beta/Characters/Evie.png"),
	"dave_d": preload("res://Art/Beta/Characters/Dave.png"),
	"maria_d": preload("res://Art/Beta/Characters/Maria.png"),
	"gina_d": preload("res://Art/Beta/Characters/Gina.png"),
	"perla_d": preload("res://Art/Beta/Characters/Perla.png"),
}

var perceptions = {
	"gp": preload("res://Art/Beta/Characters/GP.png"),
}

var portrait_bounce_start_time = -1.0
var portrait_bounce_duration = 0.35
var portrait_bounce_amplitude = 10.0


func _process(_delta: float) -> void:
	if not SettingsManager.bounce_mode:
		return
	if portrait_bounce_start_time < 0:
		return
	if current_target_portrait == null:
		return
	if not current_target_portrait.visible:
		return

	var now = Time.get_ticks_msec() / 1000.0
	var t = now - portrait_bounce_start_time

	if t > portrait_bounce_duration:
		portrait_bounce_start_time = -1.0
		current_target_portrait.position.y = 0
		return

	var progress = t / portrait_bounce_duration
	var decay = 2.4 - progress
	var phase = t * 18.0

	var offset = -sin(phase) * decay * portrait_bounce_amplitude
	current_target_portrait.position.y = offset


func set_mode(mode: String):
	if mode == "dialog":
		current_target_portrait = dialog_portrait
		dialog_portrait.visible = true
		shop_portrait.visible = false

	elif mode == "shop":
		current_target_portrait = shop_portrait
		shop_portrait.visible = true
		dialog_portrait.visible = false


func show_perception(name: String):
	if name == "none":
		perception.visible = false
		current_perception = ""
		return

	if name == "":
		return

	if perceptions.has(name):
		perception.texture = perceptions[name]
		perception.visible = true
		current_perception = name

func clear_portrait():
	dialog_portrait.visible = false
	shop_portrait.visible = false
	perception.visible = false

	current_portrait = ""
	current_perception = ""
	current_target_portrait = null

	portrait_bounce_start_time = -1.0


func apply_visuals(name: String, unused = ""):
	if current_target_portrait == null:
		set_mode("dialog")
	
	var previous = current_portrait

	if name == "":
		clear_portrait()
		return

	if name == "none":
		clear_portrait()
		return

	if portraits.has(name):
		current_target_portrait.texture = portraits[name]
		current_target_portrait.visible = true
		perception.visible = false

		if SettingsManager.bounce_mode and name != previous:
			portrait_bounce_start_time = Time.get_ticks_msec() / 1000.0
		else:
			portrait_bounce_start_time = -1.0
			current_target_portrait.position.y = 0

		current_portrait = name
		return

	if perceptions.has(name):
		current_target_portrait.visible = false
		show_perception(name)
		current_portrait = ""
		current_perception = name
		portrait_bounce_start_time = -1.0
		return

	clear_portrait()


func bounce_portrait():
	if current_target_portrait == null:
		return
	if not current_target_portrait.visible:
		return

	var tween = create_tween()
	current_target_portrait.scale = Vector2(1.0, 1.0)

	tween.tween_property(current_target_portrait, "scale", Vector2(1.15, 1.15), 0.12).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.tween_property(current_target_portrait, "scale", Vector2(1.0, 1.0), 0.10).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN)
