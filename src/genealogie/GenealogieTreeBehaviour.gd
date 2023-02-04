extends Spatial

export var min_distance_to_snap = 1.0
export var z_picture_distance_from_wall = 0.02
export var goal_order_pictures: Array = []

var picture_selected = null 
export var pictures_path: Array = [] 
var pictures_body = []
var pictures_signal = []
var previous_mouse_position = null

export var placeholder_path: Array = []
var placeholder_nodes: Array = []
var placeholder_picture_in: Array = []

export var mouse_speed = 0.005

# Called when the node enters the scene tree for the first time.
func _ready():
	for i in range(0, len(pictures_path)) : 
		pictures_body.append(get_node(pictures_path[i]))
		pictures_body[i].connect("on_selected", self, "on_picture_selected", [i])
	
	for i in range(0, len(placeholder_path)) :
		placeholder_nodes.append(get_node(placeholder_path[i]))
		placeholder_picture_in.append(-1)
		

func on_picture_selected(_event, picture_id):
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
		pictures_body[picture_id].translation = placeholder_nodes[closest_placeholder].translation
		pictures_body[picture_id].translation.z -= z_picture_distance_from_wall
		placeholder_picture_in[closest_placeholder] = picture_id
		
		check_end()
		
	

func _process(_delta):
	var click_position = get_viewport().get_mouse_position()
	if picture_selected != null && Input.is_mouse_button_pressed(1): # Left click
		if (previous_mouse_position != null) :
			var direction_move = previous_mouse_position - click_position 
			pictures_body[picture_selected].translation += Vector3(direction_move.x, direction_move.y, 0) * mouse_speed
	elif picture_selected != null :
		on_picture_released(picture_selected)
		picture_selected = null
		
	previous_mouse_position = click_position


