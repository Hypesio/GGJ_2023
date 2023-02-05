extends Spatial

onready var player = $Player
onready var objects = $Objects
onready var familyTree = $GenealogieTree
onready var menu = $Menu
onready var transition_rect = $SceneTransitionRect

var photos_picked = []

func _ready() -> void:
	#transition_rect.fade_in()
	menu.visible = false
	player.connect("object_picked", self, "on_object_picked")
	player.connect("pause", self, "on_pause")
	menu.connect("play", self, "on_play")

func on_object_picked(object: Obj) -> void:
	if object.type == Utils.ObjectType.PHOTO:
		photos_picked.append(object.id)
		print(object.id)
		familyTree.enable_picture(object.id)
		object.collect()
	outline_object_category(object.group)
	

func outline_object_category(group: int) -> void:
	for object in objects.get_children():
		if group == object.group:
			object.group_highlight()
		else:
			object.stop_group_highlight()

func on_pause() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	menu.visible = true
	get_tree().paused = true
	
func on_play() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	menu.visible = false
	get_tree().paused = false
