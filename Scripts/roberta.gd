#Roberta

extends TextureButton

func _ready():
	connect("pressed", Callable(self, "clicked"))

func go_back():
	self.visible = true
	Bouncer.bounce(self)

func clicked():
	self.visible = false
	if not KnowledgeManager.knows("Met_Roberta"):
		SequenceMachine.run_sequence([
			"action:learn:Met_Roberta",
 			"dialog:1121",
			"action:go_back",
			"note:[center]Met Roberta[/center]",
		], self)
		return

	else:
		SequenceMachine.run_sequence([
			"dialog:1128",
			"action:go_back",
		], self)
