extends CanvasLayer

@onready var item_cursor = $ItemCursor

signal inventory_updated
signal item_used_on_target(target: Node, item_id: String)

var slots = []
var cash: float = 0.00

const empty_slot = ""
const inventory_size = 16
const cursor_slot = inventory_size


func _process(delta):
	if item_cursor.visible:
		item_cursor.global_position = get_viewport().get_mouse_position()

func _ready():
	ready_slots()

func ready_slots():
	slots.clear()
	for i in range(inventory_size):
		slots.append("")
	slots.append("")

func format_money(amount: float) -> String:
	return "$%.2f" % amount

#Item

func item_has_attribute(id: String, attr: String):
	if not ItemDatabase.items.has(id):
		return false
	var attrs = ItemDatabase.items[id].get("attribute", [])
	return attr in attrs

func item_has_type(id: String, target_type: String):
	if not ItemDatabase.items.has(id):
		return false
	return ItemDatabase.items[id].get("type", "") == target_type

func inventory_has_type(target_type: String) -> bool:
	for id in ItemManager.slots:
		if id == "":
			continue
		if item_has_type(id, target_type):
			return true
	return false

func add_item(id: String):
	if not ItemDatabase.items.has(id):
		print("Unknown item:", id)
		return
	var empty_index = slots.find("")
	if empty_index != -1:
		slots[empty_index] = id
		emit_signal("inventory_updated")

func remove_item(id: String):
	var index = slots.find(id)
	if index != -1:
		slots[index] = empty_slot
		emit_signal("inventory_updated")

func pick_up_item(index: int):
	if slots[index] != "":
		slots[cursor_slot] = slots[index]
		slots[index] = ""
		item_cursor.texture = ItemDatabase.get_item_texture(slots[cursor_slot])
		print("[DEBUG] pick_up_item → picked:", slots[cursor_slot], 
			"cursor_slot:", cursor_slot, 
			"cursor_visible:", item_cursor.visible)
		update_cursor_icon()
		emit_signal("inventory_updated")

func drop_item(index: int):
	if slots[cursor_slot] != "":
		if slots[index] == "":
			slots[index] = slots[cursor_slot]
			slots[cursor_slot] = ""
		else:
			var temp = slots[index]
			slots[index] = slots[cursor_slot]
			slots[cursor_slot] = temp
		print("[DEBUG] drop_item → dropped into slot:", index, 
			"cursor_slot now:", slots[cursor_slot], 
			"cursor_visible:", item_cursor.visible)
		update_cursor_icon()
		emit_signal("inventory_updated")

func use_item(target: Node):
	var item_id = slots[cursor_slot]
	if item_id == "":
		return false

	if ItemDatabase.items.has(item_id) and target != null:
		emit_signal("item_used_on_target", target, item_id)

	if slots.find(item_id) == -1:
		slots[cursor_slot] = ""
	else:
		var origin = Menu.drag_origin_index
		if origin != -1:
			slots[origin] = item_id
		slots[cursor_slot] = ""

	update_cursor_icon()
	emit_signal("inventory_updated")
	return true

func use_and_remove(target: Node, item_id: String):
	if ItemDatabase.items.has(item_id):
		emit_signal("item_used_on_target", target, item_id)
		remove_item(item_id)

func sell_item(id: String) -> float:
	var item = ItemDatabase.items.get(id, null)
	if item:
		var value = float(item.get("value", 0.00))
		remove_item(id)
		cash += value
		emit_signal("inventory_updated")
		return value
	return 0.00

func spend_currency(amount: float):
	if cash >= amount:
		cash -= amount
		emit_signal("inventory_updated")
		return true
	return false

func swap_slots(a: int, b: int):
	var temp = slots[a]
	slots[a] = slots[b]
	slots[b] = temp
	emit_signal("inventory_updated")
	
func swap_or_move(old_index: int, new_index: int) -> Variant:
	if old_index == new_index:
		emit_signal("inventory_updated")
		return slots[old_index]

	var old_item = slots[old_index]
	var target_item = slots[new_index]

	if target_item != "":
		slots[new_index] = old_item
		slots[old_index] = target_item
		emit_signal("inventory_updated")
		return target_item
	else:
		slots[new_index] = old_item
		slots[old_index] = ""
		emit_signal("inventory_updated")
		return null

func update_cursor_icon():
	var id = slots[cursor_slot]
	if id != "":
		item_cursor.texture = ItemDatabase.get_item_texture(id)
		item_cursor.visible = true
	else:
		item_cursor.texture = null
		item_cursor.visible = false
