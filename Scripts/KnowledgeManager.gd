extends Node

signal knowledge_learned(id: String)

var knowledge = {}  #Achievement
var hidden_knowledge = {} #Flags

func learn(id: String):
	if not knowledge.has(id):
		knowledge[id] = true
		emit_signal("knowledge_learned", id)
		print("Learned:", id)

func knows(id: String):
	return knowledge.get(id, false)

func forget(id: String):
	if knowledge.has(id):
		knowledge.erase(id)
		print("Forgot:", id)

#Secrets

func secretly_learn(id: String):
	if not hidden_knowledge.has(id):
		hidden_knowledge[id] = true
		emit_signal("knowledge_learned", id)
		print("Secretly learned:", id)

func secretly_knows(id: String) -> bool:
	return hidden_knowledge.get(id, false)

func secretly_forget(id: String):
	if hidden_knowledge.has(id):
		hidden_knowledge.erase(id)
		print("Secretly forgot:", id)

#List

func list_all() -> Array:
	return knowledge.keys()
