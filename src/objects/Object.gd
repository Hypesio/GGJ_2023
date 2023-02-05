tool
extends RigidBody
class_name Obj

onready var obj_mesh_material: Material
onready var animation_player := get_node_or_null("AnimationPlayer")
onready var sound_stream := get_node_or_null("AudioStreamPlayer3D")
export var min_pitch = 0.92
export var max_pitch = 1.07
var shader: ShaderMaterial
export var base_outline_color: Color
export var group_outline_color: Color
export var size: float = 2.0

var is_outline := false
var is_group_outline := false
var is_held := false

export (Utils.ObjectType) var type: int
export var id: int
export (Utils.Group) var group: int
var rng = RandomNumberGenerator.new()

func _ready() -> void:
	rng.randomize()
	var mesh = $MeshInstance
#	if get_node_or_null("MeshInstance2") != null : 
#		mesh = get_node("MeshInstance2")
	print(mesh)
	mesh.get_active_material(0).next_pass = mesh.get_active_material(0).next_pass.duplicate()
	shader = mesh.get_active_material(0).next_pass
	shader.set_shader_param("thickness", 0)
	#mesh.mesh.material = mesh.mesh.material.duplicate()
	#obj_mesh_material = mesh.mesh.material
	

func _process(delta: float) -> void:
	if is_outline or is_group_outline:
		shader.set_shader_param("thickness", 0.02 + 0.03 * (1 + sin(5 * OS.get_system_time_msecs()/1000.0))/2)
	
func group_highlight():
	shader.set_shader_param("thickness", 0.1)
	shader.set_shader_param("outline_color", group_outline_color)
	is_group_outline = true
	
func stop_group_highlight():
	shader.set_shader_param("thickness", 0)
	is_group_outline = false
	
func hover_highlight():
	if not is_held:
		shader.set_shader_param("thickness", 0.1)
		shader.set_shader_param("outline_color", base_outline_color)
		is_outline = true

func stop_hover_highlight():
	if is_group_outline:
		shader.set_shader_param("outline_color", group_outline_color)
	else:
		shader.set_shader_param("thickness", 0)
	is_outline = false

func interact():
	if (sound_stream != null) : 
		var pitch = rng.randf_range(min_pitch, max_pitch)
		sound_stream.pitch_scale = pitch
		sound_stream.play()

func collect():
	if animation_player != null:
		animation_player.play("collect")
		yield(animation_player, "animation_finished")
		queue_free()
