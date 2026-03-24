extends TextureButton

@export var item_id = "pocket_knife"

func _ready():
	if KnowledgeManager.knows("Pocket_Knife_Collected"):
		queue_free()
	connect("pressed", Callable(self, "on_item_clicked"))

func on_item_clicked():
	ItemManager.add_item("pocket_knife")
	SequenceMachine.run_sequence([
		"note:[center]Got A Pocket Knife[/center]",
		"action:learn:Pocket_Knife_Collected"
	], self)
	queue_free()
