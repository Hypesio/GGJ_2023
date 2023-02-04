extends KinematicBody

const GRAVITY = -24.8
var vel = Vector3()
const MAX_SPEED = 20
const JUMP_SPEED = 18

var dir = Vector3()

const DEACCEL= 16
const MAX_SLOPE_ANGLE = 40

onready var camera = $Rotation_Helper/Camera
onready var rotation_helper = $Rotation_Helper
onready var raycast = $Rotation_Helper/Camera/RayCast
onready var hold_position = $Rotation_Helper/Camera/HoldPosition

var held_object: RigidBody
var held_object_old_position: Vector3
var held_object_old_rotation: Vector3

var focus_on_family_tree = false
var original_camera_pos: Vector3
var original_camera_rotation: Vector3
var collider_family_tree
var is_crouching := false
var ACCEL = 4.5
var family_tree_script = null

var MOUSE_SENSITIVITY = 0.05

signal object_picked (Obj)

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	

func _physics_process(delta):
	process_input(delta)
	process_movement(delta)
	
func on_family_tree() :
	family_tree_script.is_focus_on(camera)

func process_input(delta):
	if focus_on_family_tree : 
		on_family_tree()
		
	if held_object || focus_on_family_tree:
		pass
		
	else:
		# ----------------------------------
		# Walking
		dir = Vector3()
		var cam_xform = camera.get_global_transform()

		var input_movement_vector = Vector2()

		if Input.is_action_pressed("movement_forward"):
			input_movement_vector.y += 1
		if Input.is_action_pressed("movement_backward"):
			input_movement_vector.y -= 1
		if Input.is_action_pressed("movement_left"):
			input_movement_vector.x -= 1
		if Input.is_action_pressed("movement_right"):
			input_movement_vector.x += 1

		input_movement_vector = input_movement_vector.normalized()

		# Basis vectors are already normalized.
		dir += -cam_xform.basis.z * input_movement_vector.y
		dir += cam_xform.basis.x * input_movement_vector.x
		# ----------------------------------

		# ----------------------------------
		# Jumping
		if is_on_floor():
			if Input.is_action_just_pressed("movement_jump"):
				vel.y = JUMP_SPEED
		# ----------------------------------
	
	if Input.is_action_just_pressed("interact"):
		if held_object:
			emit_signal("object_picked", held_object)
			held_object.mode = RigidBody.MODE_RIGID
			var tween := create_tween().set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
			tween.tween_property(held_object, "translation", held_object_old_position, 1.0)
			tween.parallel().tween_property(held_object, "rotation_degrees", held_object_old_rotation, 1.0)
			held_object = null
		elif focus_on_family_tree : 
			focus_on_family_tree = false
			camera.global_translation = original_camera_pos
			camera.global_rotation = original_camera_rotation
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			collider_family_tree.disabled = false
		elif raycast.is_colliding():
			if (raycast.get_collider().is_in_group("FamilyTree")) :
				collider_family_tree = raycast.get_collider().get_child(0)
				collider_family_tree.disabled = true
				family_tree_script = raycast.get_collider().get_node("../../GenealogieTree")
				focus_on_family_tree = true
				Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
				# Force camera position
				var camera_pos = raycast.get_collider().get_child(1)
				original_camera_pos = camera.global_translation
				original_camera_rotation = camera.global_rotation
				camera.global_translation = camera_pos.global_translation
				camera.global_rotation = camera_pos.global_rotation
			else :
				held_object = raycast.get_collider()
				hold_position.translation.z = -held_object.size
				held_object_old_position = held_object.global_transform.origin
				held_object_old_rotation = held_object.rotation_degrees
				held_object.mode = RigidBody.MODE_KINEMATIC
				var tween := create_tween().set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
				tween.tween_property(held_object, "translation", hold_position.global_transform.origin, 1.0)	
		
	if Input.is_action_just_pressed("crouch"):
		camera.global_translation.y -= 1
		ACCEL = 0
		is_crouching = true
	elif Input.is_action_just_released("crouch"):
		camera.global_translation.y += 1
		ACCEL = 4.5
		is_crouching = false
		
	# ----------------------------------
	# Capturing/Freeing the cursor
	if Input.is_action_just_pressed("ui_cancel"):
		if Input.get_mouse_mode() == Input.MOUSE_MODE_VISIBLE:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	# ----------------------------------
	
func process_movement(delta):
	dir.y = 0
	dir = dir.normalized()

	vel.y += delta * GRAVITY

	var hvel = vel
	hvel.y = 0

	var target = dir
	target *= MAX_SPEED

	var accel
	if dir.dot(hvel) > 0:
		accel = ACCEL
	else:
		accel = DEACCEL

	hvel = hvel.linear_interpolate(target, accel * delta)
	vel.x = hvel.x
	vel.z = hvel.z
	vel = move_and_slide(vel, Vector3(0, 1, 0), 0.05, 4, deg2rad(MAX_SLOPE_ANGLE))

func _input(event):
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		if held_object:
			held_object.rotate_x(deg2rad(event.relative.y * MOUSE_SENSITIVITY))
			held_object.rotate_y(deg2rad(event.relative.x * MOUSE_SENSITIVITY))

			var object_rot = held_object.rotation_degrees
			object_rot.x = clamp(object_rot.x, -70, 70)
			held_object.rotation_degrees = object_rot
		elif not focus_on_family_tree :
			rotation_helper.rotate_x(deg2rad(event.relative.y * MOUSE_SENSITIVITY * -1))
			self.rotate_y(deg2rad(event.relative.x * MOUSE_SENSITIVITY * -1))

			var camera_rot = rotation_helper.rotation_degrees
			camera_rot.x = clamp(camera_rot.x, -70, 70)
			rotation_helper.rotation_degrees = camera_rot

		
