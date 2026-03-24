#Perla

extends TextureButton

func _ready():
	connect("pressed", Callable(self, "on_item_clicked"))

func go_back():
	self.visible = true
	Bouncer.bounce(self)

func on_item_clicked():
	self.visible = false

	if not KnowledgeManager.knows("Met_Perla"):
		SequenceMachine.run_sequence([
			"action:learn:Met_Perla",
 			"dialog:1278",
			"action:go_back",
			"note:[center]Met Perla"
		], self)
		return
	else:
		SequenceMachine.run_sequence([
			"shopdialog:1280",
			"action:go_back",
		], self)
