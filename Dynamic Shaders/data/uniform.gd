class_name Uniform

enum Type {
	INT, UINT, VEC4, COLOR, FLOAT, VEC2
}

const TYPE_TO_STR: Dictionary = {
	Type.INT: "int",
	Type.UINT: "uint",
	Type.VEC4: "vec4",
	Type.COLOR: "vec4",
	Type.FLOAT: "float",
	Type.VEC2: "vec2"
}

var _name: String = ""
var _type: Type
var _value
var _array_size: int = 0
var _snippet: String = ""

func _init(name: String, type: Type, value, array_size: int = 0):
	validate_value(type, value)
	validate_name(name)
	if (_array_size > 0):
		_array_size = array_size
	_name = name
	_type = type
	_value = value
	_array_size = array_size
	update_snippet()

func validate_value(type: Type, value):
	match(type):
		Type.INT:
			assert(value is int)
		Type.UINT:
			assert((value is int) && (value > 0))
		Type.VEC4, Type.COLOR:
			assert(value is Vector4 || value is Color)
		Type.FLOAT:
			assert(value is float)
		Type.VEC2:
			assert(value as Vector2)

const MAX_UNIFORM_NAME_LENGTH: int = 255

func validate_name(name: String):
	assert(not name.is_empty(), "Uniform name can't be empty")
	assert(Functions.is_letter(name[0]), "Uniform name must start with letter.")
	assert(name.length() < MAX_UNIFORM_NAME_LENGTH, "Max uniform name length exceeded!")

# NOTE: Possibility of performance optimization by not calling update_snippet after every
# parameter update if there will be need to do so.

func update_snippet():
	_snippet = generate_snippet()
	
func generate_snippet() -> String:
	var new_snippet: String = "uniform "
	new_snippet += TYPE_TO_STR[_type] + " " + _name
	if is_array():
		new_snippet += "[" + str(_array_size) + "]"
	new_snippet += ";"
	return new_snippet

func set_name(name: String):
	validate_name(name)
	_name = name
	update_snippet()

func set_value(value):
	validate_value(_type, value)
	_value = value

func get_value():
	return _value
	
func is_array() -> bool:
	return _array_size > 0

func get_name() -> String:
	return _name

func get_snippet() -> String:
	return _snippet
