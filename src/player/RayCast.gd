extends RayCast

var colliding_shape: StaticBody = null

func _physics_process(delta: float) -> void:
	if is_colliding():
		colliding_shape = get_collider()
		colliding_shape.highlight()
	if colliding_shape and not is_colliding():
		colliding_shape.stop_highlight()
		colliding_shape = null
		
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("interact") and colliding_shape:
		colliding_shape.interact()
