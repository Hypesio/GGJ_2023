extends ColorRect

export var next_scene_path := "res://src/main/Main.tscn"


onready var anim_player = $AnimationPlayer

func fade_in() -> void:
	anim_player.play("fade_in")

func transition_to_main() -> void:
	# Plays the Fade animation and wait until it finishes
	anim_player.play("fade_out")
	yield(anim_player, "animation_finished")
	# Changes the scene
	get_tree().change_scene(next_scene_path)
	
func end_game() -> void: 
	anim_player.play("fade_out")
	yield(anim_player, "animation_finished")
	# Changes the scene
	get_tree().change_scene(next_scene_path)
	# Thanks for playing 
	# Made for Global Game Jam 2023 in Nantes
	
