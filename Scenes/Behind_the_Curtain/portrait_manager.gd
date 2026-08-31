extends Control

@onready var perception = $Mask/Perception
@onready var dialog_portrait = $Mask/Dialog_Portrait
@onready var shop_portrait = $Mask/Shop_Portrait

var current_portrait = ""
var current_perception = ""
var current_target_portrait: TextureRect = null
var previous_speaker = ""
var dialog_default_y: float = 0.0
var shop_default_y: float = 0.0

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
	"max_d": preload("res://Art/Beta/Characters/Max.png"),
	"sammy_d": preload("res://Art/Beta/Characters/Sammy.png"),
	"jeff_d": preload("res://Art/Beta/Characters/Jeff.png"),
	"rodney_d": preload("res://Art/Beta/Characters/Rodney.png"),
	"rodney_b": preload("res://Art/Beta/Characters/Rodney_Back.png"),
}

var perceptions = {
	"chloe": preload("res://Art/Beta/Characters/Cat_Chloe.png"),
	"cleo": preload("res://Art/Beta/Characters/Cat_Cleo.png"),
	"creamy_color": preload("res://Art/Beta/Characters/Cat_Creamy_Color.png"),
	"felicia": preload("res://Art/Beta/Characters/Cat_Felicia.png"),
	"joey": preload("res://Art/Beta/Characters/Cat_Joey.png"),
	"spock": preload("res://Art/Beta/Characters/Cat_Spock.png"),
}

var portrait_bounce_start_time = -1.0
var portrait_bounce_duration = 0.35
var portrait_bounce_amplitude = 10.0

func _ready():
	dialog_default_y = dialog_portrait.position.y
	shop_default_y = shop_portrait.position.y

func _process(_delta: float):
	if not GameGlue.SettingsManager.bounce_mode:
		return
	if portrait_bounce_start_time < 0:
		return
	if current_target_portrait == null:
		return
	if not current_target_portrait.visible:
		return

	var now = Time.get_ticks_msec() / 1000.0
	var time = now - portrait_bounce_start_time

	if time > portrait_bounce_duration:
		portrait_bounce_start_time = -1.0
		var default_y = dialog_default_y if current_target_portrait == dialog_portrait else shop_default_y
		current_target_portrait.position.y = default_y
		return

	var progress = time / portrait_bounce_duration
	var decay = 2.4 - progress
	var phase = time * 18.0

	var offset = -sin(phase) * decay * portrait_bounce_amplitude
	var default_y = dialog_default_y if current_target_portrait == dialog_portrait else shop_default_y
	current_target_portrait.position.y = default_y + offset


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
	
	if name == "" or name == "none":
		clear_portrait()
		return

	if portraits.has(name):
		var texture = portraits[name]
		current_target_portrait.texture = texture
		current_target_portrait.visible = true
		perception.visible = false
		current_portrait = name
		var default_y = dialog_default_y if current_target_portrait == dialog_portrait else shop_default_y
		current_target_portrait.position.y = default_y
		return

	if perceptions.has(name):
		current_target_portrait.visible = false
		show_perception(name)
		current_portrait = ""
		current_perception = name
		return

	clear_portrait()

func bounce_on_speaker(speaker: String):
	if speaker == "Summer":
		var scene = GameGlue.get_node_or_null("Middle/Scene")
		if scene and scene.has_method("bounce_summer"):
			scene.bounce_summer()
	else:
		if current_target_portrait and current_target_portrait.visible:
			portrait_bounce_start_time = Time.get_ticks_msec() / 1000.0

func bounce_on_dialog_start():
	if current_target_portrait and current_target_portrait.visible:
		portrait_bounce_start_time = Time.get_ticks_msec() / 1000.0

func bounce_portrait():
	if current_target_portrait == null:
		return
	if not current_target_portrait.visible:
		return

	var tween = create_tween()
	current_target_portrait.scale = Vector2(1.0, 1.0)

	tween.tween_property(current_target_portrait, "scale", Vector2(1.15, 1.15), 0.12).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.tween_property(current_target_portrait, "scale", Vector2(1.0, 1.0), 0.10).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN)
