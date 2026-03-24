extends Panel

func _ready():
	NumberManager.phonebook_update.connect(update)
	update()

func update():
	var list = NumberManager.get_numbers()

	var r = $ScrollContainer/Number_List
	r.clear()

	for num in list:
		r.append_text(num + "\n")
