extends Panel

@onready var records = $ScrollContainer/RichTextLabel

func _ready():
	KnowledgeManager.knowledge_learned.connect(on_knowledge_learned)
	populate_records()
	
func populate_records():
	var knowledge: Array = KnowledgeManager.list_all()
	var text := ""
	for id in knowledge:
		text += format_record(id) + "\n"
	records.text = text

func format_record(id: String) -> String:
	return id.replace("_", " ").capitalize()

func on_knowledge_learned(id: String):
	populate_records()
