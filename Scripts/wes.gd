#Wes

extends TextureButton

func _ready():
	connect("pressed", Callable(self, "clicked"))

func go_back():
	self.visible = true
	Bouncer.bounce(self)

func clicked():
	self.visible = false
	if not KnowledgeManager.knows("Met_Wes"):
		SequenceMachine.run_sequence([
			"action:learn:Met_Wes",
 			"dialog:1091",
			"action:go_back",
			"note:[center]Met Wes[/center]",
		], self)
		return

	else:
		SequenceMachine.run_sequence([
			"dialog:1096",
			"action:go_back",
		], self)
