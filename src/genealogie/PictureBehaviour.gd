extends Spatial

var is_selected = false
var previous_mouse_position = null
var mouse_speed = 0.005

func _ready():
	var body = $PhotoTree/KinematicBody
	body.connect("input_event", self, "on_input_event")

# Call on click
func on_input_event(camera, event, click_position, click_normal, shape_idx):
	if event.is_pressed()  :
		is_selected = true

func _process(delta):
	if is_selected && Input.is_mouse_button_pressed(1): # Left click
		var click_position = get_viewport().get_mouse_position()
		if (previous_mouse_position != null) :
			var direction_move = previous_mouse_position - click_position 
			translation += Vector3(direction_move.x, direction_move.y, 0) * mouse_speed
		previous_mouse_position = click_position
	elif is_selected :
		is_selected = false


