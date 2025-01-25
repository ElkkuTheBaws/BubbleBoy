extends Node3D
class_name Hands

@export var input: PlayerInputComponent
@export var liquid: Node3D
@export_category("Sway")
@export var swaySpeed: float = 10
@export var swayAngle: float = 90

var velocity: Vector3 = Vector3.ZERO
var acceleration: float = 10
var old_velocity: Vector3

var active: bool = false:
	set(value):
		active = value
		if active:
			visible = true
		else:
			visible = false
		rotation_degrees = Vector3.ZERO

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	if active:
		calculate_sway(velocity, delta)
		rotation_degrees.z = clampf(rotation_degrees.z, -swayAngle, swayAngle)
		rotation_degrees.x = clampf(rotation_degrees.x, -swayAngle, swayAngle)
		rotation_degrees.y = 0

func move(event: InputEvent):
	if active:
		rotate_z(input.getXRotation(event) * swaySpeed)
		rotate_x(input.getYRotation(event) * swaySpeed)

func calculate_sway(vel: Vector3, delta: float):
	var speed: float = delta * swaySpeed
	
	# Calculate sway angles
	var side_sway: float = vel.dot(-global_transform.basis.x) * swayAngle
	var forward_sway: float = vel.dot(global_transform.basis.z) * swayAngle
	#print(side_sway)
	# Smoothly interpolate the rotations
	if input.input_dir.length() == 0:
		if abs(rotation_degrees.z) > 10:
			side_sway = swayAngle * float(sign(rotation_degrees.z))
			speed *= 2
		else:
			side_sway = 0.0
		if abs(rotation_degrees.x) > 10:
			forward_sway = swayAngle * float(sign(rotation_degrees.x))
			speed *= 2
		else:
			forward_sway = 0.0
	#print(side)
	
	rotation_degrees.z = lerp(rotation_degrees.z, side_sway, speed)
	rotation_degrees.x = lerp(rotation_degrees.x, forward_sway, speed)
	


#func calculate_sway(vel: Vector3, delta: float):
	#var s: float
	#var side: float
	#var forward: float
	#var speed: float = delta * swaySpeed
	#side = vel.dot(-global_transform.basis.x)
	#s = sign(side)
	#side = abs(side)
	#if (side < speed):
		#side = side * swayAngle / speed
	#else:
		#side = swayAngle
	#rotation_degrees.z = lerp(rotation_degrees.z, side*s, speed)
	#
	#forward = vel.dot(-transform.basis.z)
	#s = sign(forward)
	#forward = abs(forward)
	#if forward < speed:
		#forward = forward * swayAngle / speed
	#else:
		#forward = swayAngle
	#rotation_degrees.x = lerp(rotation_degrees.x, forward*s, speed)
	##camera.rotation_degrees.z = lerp(camera.rotation_degrees.z, side*s, speed)
