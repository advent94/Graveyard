class_name VisualEffect

enum Type {
	FADE, BLINK, CHANGE_COLOR
}

const TYPE_TO_STR: Dictionary = {
	Type.FADE: "fade",
	Type.BLINK: "blink",
	Type.CHANGE_COLOR: "change_color"
}

var _type: Type
var _unique: bool = true
var uniforms: Array[Uniform]
var fragment_snippet: String = ""
var vertex_snippet: String = ""
var id: int = _get_id()

func _get_id() -> int:
	var _id = Counters.get_instance("visual_effects").get_value()
	Counters.get_instance("visual_effects").increment()
	return _id

func is_unique() -> bool:
	return _unique

func has_uniform(name: String) -> bool:
	for uniform in uniforms:
		if uniform.get_name() == name:
			return true
	return false

func get_uniform_names() -> PackedStringArray:
	var uniform_names: PackedStringArray = []
	for uniform in uniforms:
		uniform_names.push_back(uniform.get_name())
	return uniform_names

func get_type() -> Type:
	return _type

func get_uniform_snippets() -> String:
	var snippets: String = ""
	for uniform in uniforms:
		snippets += uniform.get_snippet() + "\n"
	return snippets
