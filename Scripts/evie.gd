#Evie

extends TextureButton

func _ready():
	connect("pressed", Callable(self, "clicked"))

func go_back():
	self.visible = true
	Bouncer.bounce(self)

func clicked():
	self.visible = false
	if not KnowledgeManager.knows("Met_Evie"):
		SequenceMachine.run_sequence([
			"action:learn:Met_Evie",
 			"dialog:1130",
			"action:go_back",
			"note:[center]Met Evie[/center]",
		], self)
		return

	else:
		SequenceMachine.run_sequence([
			"dialog:1135",
			"action:go_back",
		], self)
