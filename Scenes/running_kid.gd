extends Node3D

@export var animation: AnimationPlayer
@export var animation2: AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animation.play("Animation")
	animation2.play("run")
