extends Panel

func _ready():
	call_deferred("connect_phone")


func connect_phone():
	update()
	GameGlue.NumberManager.phonebook_update.connect(update)

func update():
	var list = GameGlue.NumberManager.get_numbers()

	var r = $ScrollContainer/Number_List
	r.clear()

	for num in list:
		r.append_text(num + "\n")
