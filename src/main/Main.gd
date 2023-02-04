extends Spatial

onready var player = $Player
onready var objects = $Objects
onready var familyTree = $GenealogieTree

var photos_picked = []

func _ready() -> void:
	player.connect("object_picked", self, "on_object_picked")

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
