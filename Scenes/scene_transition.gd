extends Node

@export var animation_player: AnimationPlayer


func change_scene(path: String):
	animation_player.play("fade_in")
	await animation_player.animation_finished
	get_tree().change_scene_to_file(path)
	animation_player.play_backwards("fade_in")
