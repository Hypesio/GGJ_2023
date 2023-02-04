extends Spatial

signal on_selected(event)

var is_selected = false
var previous_mouse_position = null

func _ready():
	var body = $PhotoTree/KinematicBody
	body.connect("input_event", self, "on_input_event")

# Call on click
func on_input_event(_camera, event, _click_position, _click_normal, _shape_idx):
	print("Hovering me")
	if event.is_pressed()  :
		emit_signal("on_selected", event)


