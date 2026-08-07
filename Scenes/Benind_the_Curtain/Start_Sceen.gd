extends TextureRect

var time_accum: float = 0.0

func _process(delta: float):
	time_accum += delta
	if material is ShaderMaterial:
		material.set_shader_parameter("time_accum", time_accum)

func _ready():
	if material is ShaderMaterial:
		material.set_shader_parameter("scroll_speed", Vector2(0.02, 0.0))
