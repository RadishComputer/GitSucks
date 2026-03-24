extends Control

func _ready():
	SequenceMachine.run_sequence([
		"note:[center]Thank You for Playing!",
	], self)
