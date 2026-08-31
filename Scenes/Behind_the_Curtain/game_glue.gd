#Game Glue

extends Control

@onready var PhoneAudio: Node = $Back/PhoneAudio
@onready var DialogManager: Node = $Back/DialogManager
@onready var ItemDatabase: Node = $Back/ItemDatabase
@onready var Bouncer: Node = $Back/Bouncer
@onready var GameState: Node = $Back/GameState
@onready var ClockManager: Node = $Back/ClockManager
@onready var NumberManager: Node = $Back/NumberManager
@onready var KnowledgeManager: Node = $Back/KnowledgeManager
@onready var SaveManager: Node = $Back/SaveManager
@onready var SettingsManager: Node = $Back/SettingsManager
@onready var PhoneBook: Node = $Back/PhoneBook
@onready var SequenceMachine: Node = $Back/SequenceMachine
@onready var Menu: Node = $Back/Menu

@onready var InputManager: Node = $Front/InputManager
@onready var ItemManager: Node = $Front/ItemManager
@onready var PortraitManager: Node = $Front/PortraitManager
@onready var TextBox: Node = $Front/TextBox

@onready var FXPlayer: AudioStreamPlayer = $FX
@onready var AmbiencePlayer: AudioStreamPlayer = $Ambience

func _enter_tree() -> void:
	print("ENTER TREE:", self)

func load_scene(path: String) -> void:
	print("GameGlue: load_scene called with path = ", path)
	for child in $Middle.get_children():
		child.call_deferred("free")
		#child.queue_free()
	call_deferred("finish_load_scene", path)

func finish_load_scene(path: String) -> void:
	print("GameGlue: _finish_load_scene - loading ", path)
	var scene = load(path).instantiate()
	scene.name = "Scene"
	$Middle.add_child(scene)

func play_ambience(stream: AudioStream) -> void:
	AmbiencePlayer.stream = stream
	AmbiencePlayer.play()

func fade_out_ambience(duration: float = 2.0) -> void:
	var player = AmbiencePlayer
	if player == null or not player.playing:
		return
	var tween = create_tween()
	tween.tween_property(player, "volume_db", -80.0, duration)
	await tween.finished
	stop_ambience()
	player.volume_db = 0.0

func stop_ambience() -> void:
	AmbiencePlayer.stop()

func fade_to_black(duration = 1.5, callback = null):
	var overlay = $Back/Menu/CanvasLayer/ColorRect
	var tween = create_tween()
	tween.tween_property(
		overlay.material,
		"shader_parameter/fade_amount",
		1.0,
		duration
	)
	if callback:
		tween.finished.connect(callback)

func snap_back(duration = 1.5, callback = null):
	var overlay = $Front/Overlay
	var tween = create_tween()
	tween.tween_property(
		overlay.material,
		"shader_parameter/fade_amount",
		0.0,
		duration
	)
	if callback:
		tween.finished.connect(callback)
