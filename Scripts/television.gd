extends Control

@onready var screen = $Screen

var is_on = false

var tv_hour_images = {
	0: preload("res://Art/Beta/TV/TV_Signal.png"), #12
	1: preload("res://Art/Beta/TV/TV_Signal.png"),
	2: preload("res://Art/Beta/TV/TV_Signal.png"), #1
	3: preload("res://Art/Beta/TV/TV_Signal.png"),
	4: preload("res://Art/Beta/TV/TV_Signal.png"), #2
	5: preload("res://Art/Beta/TV/TV_Signal.png"),
	6: preload("res://Art/Beta/TV/TV_Signal.png"), #3
	7: preload("res://Art/Beta/TV/TV_Signal.png"),
	8: preload("res://Art/Beta/TV/TV_Signal.png"), #4
	9: preload("res://Art/Beta/TV/TV_Signal.png"),
	10: preload("res://Art/Beta/TV/TV_News.png"), #5
	11: preload("res://Art/Beta/TV/TV_News.png"),
	12: preload("res://Art/Beta/TV/TV_News.png"), #6
	13: preload("res://Art/Beta/TV/TV_News.png"),
	14: preload("res://Art/Beta/TV/TV_Kid.png"), #7
	15: preload("res://Art/Beta/TV/TV_Learn.png"),
	16: preload("res://Art/Beta/TV/TV_Kid.png"), #8
	17: preload("res://Art/Beta/TV/TV_Learn.png"),
	18: preload("res://Art/Beta/TV/TV_Sport.png"), #9
	19: preload("res://Art/Beta/TV/TV_Sport.png"),
	20: preload("res://Art/Beta/TV/TV_Sport.png"), #10
	21: preload("res://Art/Beta/TV/TV_Sport.png"),
	22: preload("res://Art/Beta/TV/TV_Sport.png"), #11
	23: preload("res://Art/Beta/TV/TV_Sport.png"),
	24: preload("res://Art/Beta/TV/TV_News.png"), #12
	25: preload("res://Art/Beta/TV/TV_Kid.png"),
	26: preload("res://Art/Beta/TV/TV_Comedy.png"), #1
	27: preload("res://Art/Beta/TV/TV_Sport.png"),
	28: preload("res://Art/Beta/TV/TV_Sport.png"), #2
	29: preload("res://Art/Beta/TV/TV_Sport.png"),
	30: preload("res://Art/Beta/TV/TV_Sport.png"), #3
	31: preload("res://Art/Beta/TV/TV_Sport.png"),
	32: preload("res://Art/Beta/TV/TV_Sport.png"), #4
	33: preload("res://Art/Beta/TV/TV_News.png"),
	34: preload("res://Art/Beta/TV/TV_News.png"), #5
	35: preload("res://Art/Beta/TV/TV_Comedy.png"),
	36: preload("res://Art/Beta/TV/TV_Comedy.png"), #6
	37: preload("res://Art/Beta/TV/TV_Talk.png"),
	38: preload("res://Art/Beta/TV/TV_Game.png"), #7
	39: preload("res://Art/Beta/TV/TV_Game.png"),
	40: preload("res://Art/Beta/TV/TV_Talk.png"), #8
	41: preload("res://Art/Beta/TV/TV_Talk.png"),
	42: preload("res://Art/Beta/TV/TV_Music.png"), #9
	43: preload("res://Art/Beta/TV/TV_Scifi.png"),
	44: preload("res://Art/Beta/TV/TV_Scifi.png"), #10
	45: preload("res://Art/Beta/TV/TV_Scifi.png"),
	46: preload("res://Art/Beta/TV/TV_Scifi.png"), #11
	47: preload("res://Art/Beta/TV/TV_Scifi.png"),
}

var tv_off_image = preload("res://Art/Beta/TV/TV.png")
var tv_turn_on_image = preload("res://Art/Beta/TV/TV_On.png")
var tv_turn_off_image = preload("res://Art/Beta/TV/TV_Off.png")

func _ready():
	is_on = KnowledgeManager.secretly_knows("Front_Room_TV_On")
	update_tv_image()
	$"../Dials".input_event.connect(click)

func click(viewport, event, shape_idx):
	if InputManager.click_release(event):
		toggle_tv()

func toggle_tv():
	if is_on:
		turn_off()
	else:
		turn_on()

func turn_on():
	is_on = true
	KnowledgeManager.secretly_learn("Front_Room_TV_On")
	screen.texture = tv_turn_on_image
	await get_tree().create_timer(0.05).timeout
	update_tv_image()

func turn_off():
	is_on = false
	KnowledgeManager.secretly_forget("Front_Room_TV_On")
	screen.texture = tv_turn_off_image
	await get_tree().create_timer(0.05).timeout
	screen.texture = tv_off_image

func update_tv_image():
	if not is_on:
		screen.texture = tv_off_image
		return

	var hour = int(ClockManager.hours)
	var minute = int(ClockManager.minutes)

	# Convert to half-hour index (0–47)
	var halfhour_index = hour * 2
	if minute >= 30:
		halfhour_index += 1

	if tv_hour_images.has(halfhour_index):
		screen.texture = tv_hour_images[halfhour_index]
	else:
		screen.texture = tv_hour_images[0]
