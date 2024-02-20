extends Node

## Owner to array of effects
var _active_vfx_index: Dictionary = {}
## Owner to shader recipes
var _shader_recipe_index: Dictionary = {}

class VisualEffectData:
	var vfx: VisualEffect
	var is_permanent: bool = false
	var repetitions: int = 0

	func _init(_vfx: VisualEffect, perma: bool = true, reps: int = 0):
		assert(reps >= 0, "Repetitions value can't be negative")
		vfx = _vfx
		is_permanent = perma
		repetitions = reps

func add(_owner: CanvasItem, effect: VisualEffect, is_permanent: bool = false, repetitions: int = 0):
	if _active_vfx_index.has(_owner):
		if effect.is_unique():
			for _data in _active_vfx_index[_owner]:
				if _data.vfx.get_type() == effect.get_type():
					push_warning("Tried to multiply unique effect: \"%s\"" % VisualEffect.TYPE_TO_STR[effect.get_type()])
					return
	else:
		_owner.material = create_default_shader_material()
		_shader_recipe_index[_owner] = ShaderRecipe.new([])
		_active_vfx_index[_owner] = []
		var callable: Callable = Callable(self, "remove_owner")
		callable = callable.bind(_owner)
		_owner.connect("tree_exiting", callable)
	var data: VisualEffectData = VisualEffectData.new(effect, is_permanent, repetitions)
	update_shader_and_start(_owner, data)

func create_default_shader_material() -> ShaderMaterial:
	var material: ShaderMaterial = ShaderMaterial.new()
	var shader: Shader = Shader.new()
	shader.set_code("shader_type canvas_item;")
	material.shader = shader
	return material
	
func update_shader_and_start(_owner, data):
	_active_vfx_index[_owner].push_back(data)
	_shader_recipe_index[_owner].add_new_effect(data.vfx)
	_owner.material.shader.set_code(_shader_recipe_index[_owner].generate_script())
	start_effect(_owner, data)

func update_uniform(_owner: CanvasItem, uniform_name: String, modifier: float, counter: Counter, time: float):
	_owner.material.set_shader_parameter(uniform_name, modifier * counter.get_value())
	if not counter.is_finished:
		get_tree().create_timer(time).timeout.connect(counter.increment)

func setup_fade(_owner, data):
	set_default_uniform_values(_owner, data)
	var fade: FadeVfx = data.vfx as FadeVfx
	var updates: int = ceil(fade.time/fade.update_time)
	var uniform_name: String = fade.uniforms[1].get_name()
	var counter: Counter = Counters.register(uniform_name, Counter.new(updates))
	var callable: Callable = Callable(self, "update_uniform")
	callable = callable.bind(_owner, uniform_name, 1.0/updates, counter, fade.update_time)
	var callable2: Callable = func(): 
		counter.incremented.disconnect(callable) 
	_owner.tree_exiting.connect(callable2)
	counter.incremented.connect(callable)
	get_tree().create_timer(fade.update_time).timeout.connect(counter.increment)

func start_effect(_owner, data):
	match(data.vfx.get_type()):
		VisualEffect.Type.FADE:
			setup_fade(_owner, data)

func set_default_uniform_values(_owner, data):
	for uniform in data.vfx.uniforms:
		_owner.material.set_shader_parameter(uniform.get_name(), uniform.get_value())
	
func remove_owner(_owner: Node):
	_shader_recipe_index.erase(_owner)
	_active_vfx_index.erase(_owner)
