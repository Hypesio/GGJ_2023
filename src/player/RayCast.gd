extends RayCast

var colliding_shape: RigidBody = null

func _physics_process(delta: float) -> void:
	if colliding_shape and not is_instance_valid(colliding_shape):
		colliding_shape = null
	if is_colliding():
		colliding_shape = get_collider()
		colliding_shape.hover_highlight()
	if colliding_shape and not is_colliding():
		colliding_shape.stop_hover_highlight()
		colliding_shape = null
