extends Panel

signal inventory_updated
signal slot_created(index, button)

@onready var grid = $GridContainer

func _ready():
	GameGlue.ItemManager.inventory_updated.connect(populate_inventory)
	call_deferred("populate_inventory")

func populate_inventory():
	for child in grid.get_children():
		child.queue_free()

	for i in range(GameGlue.ItemManager.inventory_size):
		var id = GameGlue.ItemManager.slots[i]
		var btn = TextureButton.new()

		btn.stretch_mode = TextureButton.STRETCH_KEEP_ASPECT_CENTERED
		btn.texture_normal = load("res://Art/Beta/Items/Empty_Slot.png")

		if id != "" and GameGlue.ItemDatabase.item.has(id):
			btn.texture_normal = GameGlue.ItemDatabase.get_item_texture(id)
		else:
			pass

		grid.add_child(btn)
		
		btn.mouse_entered.connect(_on_item_slot_mouse_entered.bind(i))
		btn.mouse_exited.connect(_on_item_slot_mouse_exited)
		
		emit_signal("slot_created", i, btn)

	$Details.text = "Cash: $" + str(GameGlue.ItemManager.cash)


func _on_item_slot_mouse_entered(slot_index):
	var id = GameGlue.item.slots[slot_index]

	if id == "" or not GameGlue.ItemDatabase.items.has(id):
		$Tip.visible = false
		return

	var item_name = GameGlue.ItemDatabase.get_item(id).get("name", id)
	$Tip.text = "[right]%s[/right]" % item_name
	$Tip.visible = true


func _on_item_slot_mouse_exited():
	$Tip.visible = false
