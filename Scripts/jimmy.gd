#Jimmy

extends TextureButton

func _ready():
	connect("pressed", Callable(self, "clicked"))

func go_back():
	self.visible = true
	Bouncer.bounce(self)

func clicked():
	self.visible = false
	if not KnowledgeManager.knows("Met_Jimmy"):
		SequenceMachine.run_sequence([
			"action:learn:Met_Jimmy",
 			"dialog:1137",
			"action:go_back",
			"note:[center]Met Jimmy[/center]",
		], self)
		return

	else:
		SequenceMachine.run_sequence([
			"dialog:1142",
			"action:go_back",
		], self)
