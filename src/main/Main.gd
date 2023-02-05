extends Spatial

onready var player = $Player
onready var objects = $Objects
onready var familyTree = $GenealogieTree
onready var menu = $Menu
onready var transition_rect = $SceneTransitionRect
onready var doorSound = $AudioStreamPlayer
onready var footSteps = $AudioStreamPlayerFoot
onready var footSteps2 = $AudioStreamPlayerFoot2

export var time_between_steps = 0.6
export var durationSteps = 5.0
export var timeBeforeDoorSound = 5.0
export var min_pitch = 0.9
export var max_pitch = 1.1


var photos_picked = []
var time_passed = 0.0
var soundDone = false
var elapsed_time = 0.0
var rng = RandomNumberGenerator.new()
var played_right = false

func _ready() -> void:
	rng.randomize()
	transition_rect.visible = true
	transition_rect.modulate.a = 1
	transition_rect.fade_in()
	menu.visible = false
	player.connect("object_picked", self, "on_object_picked")
	player.connect("pause", self, "on_pause")
	menu.connect("play", self, "on_play")

func _process(delta):
	if (!soundDone) : 
		time_passed += delta
		if (timeBeforeDoorSound < time_passed) : 
			doorSound.play()
			soundDone = true
		elif (time_passed < durationSteps) :
			play_sound(delta)

func play_sound(delta) :
	elapsed_time += delta
	if (elapsed_time > time_between_steps) : 
		elapsed_time = 0.0
		var pitch = rng.randf_range(min_pitch, max_pitch)
		if (played_right) : 
			footSteps.pitch_scale = pitch
			footSteps.play()
			played_right = false
		else :
			footSteps.pitch_scale = pitch
			footSteps.play()
			played_right = true

func on_object_picked(object: Obj) -> void:
	if object.type == Utils.ObjectType.PHOTO:
		photos_picked.append(object.id)
		print(object.id)
		familyTree.enable_picture(object.id)
		object.collect()
#	outline_object_category(object.group)
	outline_object_category(object.get_groups()) 
	

#func outline_object_category(group: int) -> void:
func outline_object_category(groups: Array) -> void:
	#for object in objects.get_children():
	#	if group == object.group:
	#		object.group_highlight()
	#	else:
	#		object.stop_group_highlight()
	print(groups)
	for object in objects.get_children():
		var is_in_group = false
		for group in groups:
			if (group == "idle_process") :
				continue
			if group in object.get_groups():
				object.group_highlight()
				is_in_group = true
		if not is_in_group:
			object.stop_group_highlight()
			
func on_pause() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	menu.visible = true
	get_tree().paused = true
	
func on_play() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	menu.visible = false
	get_tree().paused = false
	
func end_game() -> void : 
	$SceneTransitionRect.end_game()
