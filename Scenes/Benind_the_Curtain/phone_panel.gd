extends Panel

func _ready():
	call_deferred("connect_phone")


func connect_phone():
	update()
	GameGlue.NumberManager.phonebook_update.connect(update)

func update():
	var list = GameGlue.NumberManager.get_numbers()

	var list_of_numbers = $ScrollContainer/Number_List
	list_of_numbers.clear()

	for num in list:
		list_of_numbers.append_text(num + "\n")
