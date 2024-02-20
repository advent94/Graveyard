class_name FadeVfx

extends VisualEffect

var time: float
var update_time: float

func _init(color: Color, _time: float, _update_time: float):
	assert(_time >= 0.0 && _update_time >= 0.0, "Time can't be negative")
	
	time = _time
	update_time = _update_time
	
	_type = Type.FADE
	_unique = false
	
	var fade_color: String = "fade_color" + str(id)
	var fade_modifier: String = "fade_modifier" + str(id)
	
	uniforms.push_back(Uniform.new(fade_color, Uniform.Type.COLOR, color))
	uniforms.push_back(Uniform.new(fade_modifier, Uniform.Type.FLOAT, 0.0))
	
	update_snippets(fade_color, fade_modifier)

func update_snippets(fade_color: String, fade_modifier: String):
	fragment_snippet = "    COLOR.rgb = COLOR.rgb + (" + fade_modifier + " * vec3(" + fade_color + ".rgb - COLOR.rgb));"
