extends Node3D
class_name FootstepManager
@export var player: Player
@export_category("Footstep sounds")
@export var step_sounds: Array[AudioStreamWAV]


@onready var audioPlayer = $AudioStreamPlayer3D

func _on_head_component_on_step():
	audioPlayer.volume_db = randf_range(-10, 0)
	audioPlayer.stream = step_sounds.pick_random()
	audioPlayer.pitch_scale = randf_range(0.8, 1.2)
	audioPlayer.play()
