extends Control

func _ready():
	$Control/Start_New.pressed.connect(start_new_clicked)
	$Control/Load.pressed.connect(load_clicked)
	$Control/Options.pressed.connect(options_clicked)

func start_new_clicked():
	GameGlue.load_scene("res://Scenes/Benind_the_Curtain/Intro.tscn")
	queue_free()

func load_clicked():
	print ("test")

func options_clicked():
	print ("test")
