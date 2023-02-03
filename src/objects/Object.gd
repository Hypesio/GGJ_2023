extends StaticBody
class_name Obj

var obj_mesh_material
export var normal_color := Color(0, 0, 1)
export var highlight_color := Color(1, 1, 1)

func _ready() -> void:
	yield(get_parent(), "ready")
	obj_mesh_material = get_parent().mesh.material
	obj_mesh_material.albedo_color = normal_color

func highlight():
	obj_mesh_material.albedo_color = highlight_color

func stop_highlight():
	obj_mesh_material.albedo_color = normal_color

func interact():
	print("interacting...")
