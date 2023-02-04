extends Control

export var interact_text_path: NodePath

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func enable_text_interact(show) : 
	get_node(interact_text_path).visible = show
