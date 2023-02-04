extends RigidBody
class_name Obj

onready var obj_mesh_material: Material
export var normal_color: Color
export var hover_highlight_color: Color
export var group_highlight_color: Color

var group_highlight := false

export (Utils.ObjectType) var type: int
export var id: int
export (Utils.Group) var group: int

func _ready() -> void:
	$MeshInstance.mesh.material = $MeshInstance.mesh.material.duplicate()
	obj_mesh_material = $MeshInstance.mesh.material
	obj_mesh_material.albedo_color = normal_color

func group_highlight():
	group_highlight = true
	obj_mesh_material.albedo_color = group_highlight_color
	
func stop_group_highlight():
	if group_highlight:
		group_highlight = false
		obj_mesh_material.albedo_color = normal_color
	
func hover_highlight():
	obj_mesh_material.albedo_color = hover_highlight_color

func stop_hover_highlight():
	if group_highlight:
		obj_mesh_material.albedo_color = group_highlight_color
	else:
		obj_mesh_material.albedo_color = normal_color

func interact():
	print("interacting...")
