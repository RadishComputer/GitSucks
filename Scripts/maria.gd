#Maria

extends TextureButton

func _ready():
	connect("pressed", Callable(self, "on_item_clicked"))

func go_back():
	self.visible = true
	Bouncer.bounce(self)

func on_item_clicked():
	self.visible = false

	if not KnowledgeManager.knows("Met_Maria"):
		SequenceMachine.run_sequence([
			"action:learn:Met_Maria",
 			"dialog:1238",
			"action:go_back",
			"note:[center]Met Maria"
		], self)
		return
	else:
		SequenceMachine.run_sequence([
			"shopdialog:1240",
			"action:go_back",
		], self)
