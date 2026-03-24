#Jessica

extends TextureButton

func _ready():
	connect("pressed", Callable(self, "clicked"))

func go_back():
	self.visible = true
	Bouncer.bounce(self)

func clicked():
	self.visible = false

	if not KnowledgeManager.knows("Met_Jessica"):
		SequenceMachine.run_sequence([
			"action:learn:Met_Jessica",
			"dialog:1098",  # always start here
			"action:go_back",
			"note:[center]Met Jessica[/center]",
		], self)
	else:
		SequenceMachine.run_sequence([
			"dialog:1110",
			"action:go_back",
		], self)
