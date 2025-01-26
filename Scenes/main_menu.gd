extends Node

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("input_interaction"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _on_start_pressed() -> void:
	SceneTransition.change_scene("res://Scenes/Game.tscn")
