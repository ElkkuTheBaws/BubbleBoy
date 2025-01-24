class_name PlayerInputComponent
extends Node

@export_range(0, 0.5) var mouse_sensitivity: float = 0.25
var input_dir: Vector2 = Vector2.ZERO
var bodyRotation: float = 0
var headRotation: float = 0

signal interact_action


func _input(event):
	if not Global.paused:
		if event.is_action_pressed("input_interaction"):
			interact_action.emit()

func setMovementInput():
	input_dir = Input.get_vector("input_left", "input_right", "input_up", "input_down")

func getXRotation(event: InputEvent) -> float:
	if event is InputEventMouseMotion:
		return deg_to_rad(-event.relative.x * mouse_sensitivity)
	return 0

func getYRotation(event: InputEvent):
	if event is InputEventMouseMotion:
		return deg_to_rad(-event.relative.y * mouse_sensitivity)
	return 0
