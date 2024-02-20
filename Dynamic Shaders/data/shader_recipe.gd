class_name ShaderRecipe

enum ShaderType {
	FRAGMENT, VERTEX
}

const SHADER_TYPE_TO_STR: Dictionary = {
	ShaderType.FRAGMENT: "fragment",
	ShaderType.VERTEX: "vertex",
}

var uniforms: Dictionary = {}
var vertex_snippets: Dictionary = {}
var fragment_snippets: Dictionary = {}

func _init(effects: Array[VisualEffect]):
	for effect in effects:
		add_new_effect(effect)

func add_new_effect(effect: VisualEffect):
	init_arrays(effect)
	uniforms[effect].push_back(effect.get_uniform_snippets())
	vertex_snippets[effect].push_back(effect.vertex_snippet)
	fragment_snippets[effect].push_back(effect.fragment_snippet)

func init_arrays(effect: VisualEffect):
		uniforms[effect] = []
		vertex_snippets[effect] = []
		fragment_snippets[effect] = []

func generate_uniforms() -> String:
	var snippet: String = ""
	for key in uniforms.keys():
		for uniform in uniforms[key]:
			snippet += uniform + "\n"
	return snippet

func generate_shader(type: ShaderType, snippet_index: Dictionary) -> String:
	var shader = "void " + SHADER_TYPE_TO_STR[type] + "() {\n"
	for key in snippet_index:
		for snippet in snippet_index[key]:
			shader += snippet + "\n\n"
	shader += "}\n\n"
	return shader

func generate_script() -> String:
	var script = "shader_type canvas_item;" + Constants.NEW_LINE + Constants.NEW_LINE
	script += generate_uniforms()
	script += generate_shader(ShaderType.VERTEX, vertex_snippets)
	script += generate_shader(ShaderType.FRAGMENT, fragment_snippets)
	return script

func _exit_tree():
	print("Test")
