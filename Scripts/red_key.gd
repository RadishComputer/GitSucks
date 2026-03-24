extends TextureButton

@export var item_id = "red_key"

func _ready():
	if KnowledgeManager.knows("Red_Key_Collected"):
		queue_free()
	connect("pressed", Callable(self, "on_item_clicked"))

func on_item_clicked():
	ItemManager.add_item("red_key")
	SequenceMachine.run_sequence([
		"note:[center]Got A Red Key[/center]",
		"action:learn:Red_Key_Collected"
	], self)
	queue_free()
