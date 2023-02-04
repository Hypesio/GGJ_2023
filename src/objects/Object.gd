tool
extends RigidBody
class_name Obj

onready var obj_mesh_material: Material
onready var animation_player := $AnimationPlayer
var shader: ShaderMaterial
export var base_outline_color: Color
export var group_outline_color: Color
export var size: float

var is_outline := false
var is_group_outline := false
var is_held := false

export (Utils.ObjectType) var type: int
export var id: int
export (Utils.Group) var group: int

func _ready() -> void:
	$MeshInstance.get_active_material(0).next_pass = $MeshInstance.get_active_material(0).next_pass.duplicate()
	shader = $MeshInstance.get_active_material(0).next_pass
	shader.set_shader_param("thickness", 0)
	$MeshInstance.mesh.material = $MeshInstance.mesh.material.duplicate()
	obj_mesh_material = $MeshInstance.mesh.material

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
	print("interacting...")

func collect():
	animation_player.play("collect")
	yield(animation_player, "animation_finished")
	queue_free()
