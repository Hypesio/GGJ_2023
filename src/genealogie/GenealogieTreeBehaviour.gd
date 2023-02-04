extends Spatial

export var min_distance_to_snap = 0.15
export var z_picture_distance_from_wall = 0.02
export var goal_order_pictures: Array = []
export var pictures_enable = []
onready var sound_stream: AudioStreamPlayer3D = $AudioStreamPlayer3D 

var picture_selected = null 
var actual_hovered = null
export var pictures_path: Array = [] 
var pictures_body = []
var pictures_signal = []
var pictures_kinematic = []

var previous_mouse_position = null

export var placeholder_path: Array = []
var placeholder_nodes: Array = []
var placeholder_picture_in: Array = []
var is_outline := false

export var mouse_speed = 0.005

var shader: ShaderMaterial
export var outline_color: Color

# Called when the node enters the scene tree for the first time.
func _ready():
	for i in range(0, len(pictures_path)) : 
		pictures_body.append(get_node(pictures_path[i]))
		pictures_body[i].connect("on_selected", self, "on_picture_selected", [i])
		pictures_kinematic.append(pictures_body[i].get_node("PhotoTree/KinematicBody"))
	
	for i in range(0, len(placeholder_path)) :
		placeholder_nodes.append(get_node(placeholder_path[i]))
		placeholder_picture_in.append(-1)
	
	for i in range(0, len(pictures_body)) : 
		pictures_body[i].visible = pictures_enable[i]
	
	$Background.get_active_material(0).next_pass = $Background.get_active_material(0).next_pass.duplicate()
	shader = $Background.get_active_material(0).next_pass
	shader.set_shader_param("thickness", 0)
	$Background.mesh.material = $Background.mesh.material.duplicate()
		
func _process(delta: float) -> void:
	if is_outline:
		shader.set_shader_param("thickness", 0.02 + 0.03 * (1 + sin(5 * OS.get_system_time_msecs()/1000.0))/2)
		
func is_focus_on(camera) : 
	if Input.is_mouse_button_pressed(1) : 
		on_clicked()
	else :
		on_released()
	
	var space_state = get_world().direct_space_state
	var mouse_pos = get_viewport().get_mouse_position()
	var ray_len = 3.0
	var from = camera.project_ray_origin(mouse_pos)
	var to = from + camera.project_ray_normal(mouse_pos) * ray_len
	var hit_info = space_state.intersect_ray(from, to, [], 1 << 4)
	# Get who is hovered 
	if (len(hit_info) != 0 && picture_selected == null) :
		#print(hit_info)
		if (hit_info.collider.is_in_group("Picture")) : 
			for i in range(0, len(pictures_kinematic)) : 
				if pictures_kinematic[i] == hit_info.collider : 
					actual_hovered = i
					break;
		else :
			actual_hovered = null
	# Move
	elif (len(hit_info) != 0 && picture_selected != null) :
		pictures_body[picture_selected].global_translation = hit_info.position
		pictures_body[picture_selected].translation.z = z_picture_distance_from_wall
	else : 
		actual_hovered = null
	
		
func on_clicked() : 
	if (actual_hovered != null && picture_selected == null) :
		on_picture_selected(actual_hovered)

func on_released() : 
	if (picture_selected != null) :
		on_picture_released(picture_selected)
		picture_selected = null
	

func on_picture_selected(picture_id):
	sound_stream.play()
	picture_selected = picture_id
	
	# Picture out of the placeholder
	var index = placeholder_picture_in.find(picture_id, 0)
	if (index != -1) :
		placeholder_picture_in[index] = -1

func check_end() :
	var is_correct = true
	for i in range(0, len(goal_order_pictures)) : 
		if (goal_order_pictures[i] != placeholder_picture_in[i]) :
			is_correct = false
			break; 
	if is_correct : 
		print("The Tree is completed !")
	
		
func on_picture_released(picture_id) : 
	sound_stream.play()
	var min_distance = -1 
	var closest_placeholder = 0
	for i in range(0, len(placeholder_nodes)) :
		var dist = placeholder_nodes[i].translation.distance_to(pictures_body[picture_id].translation)
		if (min_distance == -1 || dist < min_distance) :
			min_distance = dist
			closest_placeholder = i
	
	# Snap on placeholder only if the place is free
	if (min_distance < min_distance_to_snap && placeholder_picture_in[closest_placeholder] == -1) :
		print("Snap picture ", picture_id, " on ", closest_placeholder)
		pictures_body[picture_id].global_translation = placeholder_nodes[closest_placeholder].global_translation
		pictures_body[picture_id].translation.z = z_picture_distance_from_wall
		placeholder_picture_in[closest_placeholder] = picture_id
		
		check_end()

func enable_picture(id) : 
	pictures_body[id].visible = true

func hover_highlight():
	shader.set_shader_param("thickness", 0.1)
	shader.set_shader_param("outline_color", outline_color)
	is_outline = true

func stop_hover_highlight():
	shader.set_shader_param("thickness", 0)
	is_outline = false
