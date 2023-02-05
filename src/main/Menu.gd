extends Control

onready var transition_rect := $SceneTransitionRect
signal play

func _ready() -> void:
	transition_rect.modulate.a = 0
	
func _on_Play_button_down() -> void:
	if get_tree().root.get_child(1) is Control:
		transition_rect.transition_to_main()
	else:
		emit_signal("play")

func _on_Quit_button_down() -> void:
	get_tree().quit()
