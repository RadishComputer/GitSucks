#Start Screen

extends Control

func _ready():
	GameGlue.play_ambience(preload("res://Sounds/Salmon_Run_Summer.wav"))
	$Control/Start_New.pressed.connect(start_new_clicked)
	$Control/Load.pressed.connect(load_clicked)
	$Control/Options.pressed.connect(options_clicked)
	$Control/Quit.pressed.connect(quit_clicked)
	GameGlue.SettingsManager.apply_text_theme()
	print(ProjectSettings.globalize_path("user://savegame.json"))

func start_new_clicked():
	#GameGlue.stop_ambience()
	GameGlue.load_scene("res://Scenes/Behind_the_Curtain/Intro.tscn")
	queue_free()

func load_clicked():
	if GameGlue.SaveManager.load_game():
		await GameGlue.fade_out_ambience(2.0)
		queue_free()
	else:
		print("No save file found.")

func options_clicked():
	$OptionsPanel.visible = not $OptionsPanel.visible
	$Screen.visible = not $Screen.visible
	$Background/Window/Title.visible = not $Background/Window/Title.visible

func quit_clicked():
	get_tree().quit()
