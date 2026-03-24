#Dave

extends TextureButton

func _ready():
	connect("pressed", Callable(self, "clicked"))

func go_back():
	self.visible = true
	Bouncer.bounce(self)

func clicked():
	self.visible = false
	SequenceMachine.run_sequence([
			"dialog:1177",  
			"action:go_back",
		], self)
