class_name PlayerHeadComponent
extends Area3D

@export_category("FOVs")
@export_range(70,100) var defaultFov: float = 90
@export_range(70,100) var sprintFov: float = 95
@export_range(0, 20) var fovLerp: float = 10

@export_category("Side sway")
@export_range(0, 10) var swayAngle: float = 2
@export_range(1, 10) var swaySpeed: float = 2

@export_category("Head rotation")
@export_range(0, 150) var rotationLimitUp: float = 85
@export_range(-150, 0) var rotationLimitDown: float = -85

@export_category("Head bob")
@export_range(0,0.5) var headBobIntensityRunning: float = 0.2
@export_range(0,0.5) var headBobIntensityWalking: float = 0.1
@export_range(0,0.5) var headBobIntensityCrouching: float = 0.05

@export_range(0, 30) var headBobSpeedRunning: float = 20
@export_range(0, 30) var headBobSpeedWalking: float = 15
@export_range(0, 30) var headBobSpeedCrouching: float = 5

@export_range(0, 15) var headBobLerp: float = 10

@export_category("Screen shake")
@export var noise: Noise

var shake_time: float = 0.0
var local_initial_camera_rotation: Vector3
var current_noise_speed = 0.0
@export_group("Quick trauma")
@export var trauma_reduction_rate: float = 1.0
@export var quick_noise_speed = 50.0
@export var max_x: float = 10.0
@export var max_y: float = 10.0
@export var max_z: float = 5.0
var trauma: float = 0
@export_group("Constant trauma")
@export var c_noise_speed = 50.0
@export var c_max_x: float = 10.0
@export var c_max_y: float = 10.0
@export var c_max_z: float = 5.0
var c_trauma: float = 0
var c_old_trauma: float = 0

@export_category("Required Components")
@export var camera: PhantomCamera3D
@export var sub_cam: Camera3D
@export var eyes: Node3D
#@export var headAnimation: AnimationPlayer

signal on_step
var stepped: bool = false

var lastHeadPosition: Vector3 = Vector3.ZERO

var headBobVector: Vector2 = Vector2.ZERO
var headBobIndex: float = 0
var headBobCurrentIntensity: float = 0

var currentHeadHeight = 0.3

func _ready():
	#camera.fov = defaultFov
	camera.set_fov(defaultFov)
	local_initial_camera_rotation = eyes.rotation_degrees as Vector3

func _process(delta):
	shake_time += delta
	constant_trauma(delta)
	quick_trauma(delta)
	var x_rotation = local_initial_camera_rotation.x + max_x * get_shake_intensity() * get_noise_from_seed(0)
	var y_rotation = local_initial_camera_rotation.y + max_y * get_shake_intensity() * get_noise_from_seed(1)
	var z_rotation = local_initial_camera_rotation.z + max_z * get_shake_intensity() * get_noise_from_seed(2)
	var x_c_rotation = local_initial_camera_rotation.x + c_max_x * get_c_shake_intensity() * get_c_noise_from_seed(0)
	var y_c_rotation = local_initial_camera_rotation.y + c_max_y * get_c_shake_intensity() * get_c_noise_from_seed(1)
	var z_c_rotation = local_initial_camera_rotation.z + c_max_z * get_c_shake_intensity() * get_c_noise_from_seed(2)
	eyes.rotation_degrees.x = lerp(x_c_rotation, x_rotation, trauma)
	eyes.rotation_degrees.y = lerp(y_c_rotation, y_rotation, trauma)
	eyes.rotation_degrees.z = lerp(z_c_rotation, z_rotation, trauma)
	sub_cam.global_transform = camera.global_transform

func _physics_process(delta):
	position.y = lerp(position.y, currentHeadHeight, delta*10)

func rotateHead(headRotation: float):
	rotate_x(headRotation)
	rotation.x = clamp(rotation.x, deg_to_rad(rotationLimitDown), deg_to_rad(rotationLimitUp))

func setHeadHeight(height: float):
	currentHeadHeight = height

func applySmoothStepCamera(last_pos: Vector3, delta: float):
	position.y -= last_pos.y

func calculate_side_sway(vel: Vector3, delta: float):
	var s: float
	var side: float
	var speed: float = delta * swaySpeed
	side = vel.dot(-global_transform.basis.x)
	s = sign(side)
	side = abs(side)
	if (side < speed):
		side = side * swayAngle / speed
	else:
		side = swayAngle
	camera.rotation_degrees.z = lerp(camera.rotation_degrees.z, side*s, speed)

func setHeadBobSprint(delta: float):
	headBobCurrentIntensity = headBobIntensityRunning
	headBobIndex += headBobSpeedRunning*delta

func setHeadBobWalking(delta: float):
	headBobCurrentIntensity = headBobIntensityWalking
	headBobIndex += headBobSpeedWalking*delta

func setHeadBobCrouch(delta: float):
	headBobCurrentIntensity = headBobIntensityCrouching
	headBobIndex += headBobSpeedCrouching*delta

func applyJumpAnimation():
	pass
	#headAnimation.play("player_jump")

func applyLandAnimation():
	pass
	# headAnimation.play("player_land")

func headBobWalk(direction: Vector2, delta: float):
	setHeadBobWalking(delta)
	camera.set_fov(lerp(camera.get_fov(), defaultFov, delta*fovLerp))
	applyHeadBob(direction, delta)
func headBobCrouch(direction: Vector2, delta: float):
	setHeadBobCrouch(delta)
	camera.set_fov(lerp(camera.get_fov(), defaultFov, delta*fovLerp))
	applyHeadBob(direction, delta)
func headBobSprint(direction: Vector2, delta: float):
	setHeadBobSprint(delta)
	camera.set_fov(lerp(camera.get_fov(), sprintFov, delta*fovLerp))
	applyHeadBob(direction, delta)
	
func applyHeadBob(direction: Vector2,  delta: float):
	if direction != Vector2.ZERO:
		headBobVector.y = sin(headBobIndex)
		eyes.position.y = lerp(eyes.position.y, headBobVector.y*(headBobCurrentIntensity/2), delta * headBobLerp)
		if headBobVector.y <= -0.98 and not stepped:
			stepped = true
			on_step.emit()
		elif headBobVector.y >= 0:
			stepped = false
	else:
		eyes.position.y = lerp(eyes.position.y,0.0, delta * headBobLerp)
		headBobVector.y = 0
		stepped = false

func applyGroundHeadBob(dir: Vector3, delta: float):
	headBobWalk(Vector2(dir.x, dir.z), delta)

func add_trauma(trauma_amount: float):
	trauma = clamp(trauma + trauma_amount, 0.0, 1.0)
	if trauma_amount > 0.7:
		camera.set_fov(85) 

func add_constant_trauma(trauma_amount: float):
	c_old_trauma = c_trauma if trauma_amount <= 0 else 0
	c_trauma = clamp(trauma_amount, 0.0, 1.0)

func quick_trauma(delta):
	trauma = max(trauma - delta * trauma_reduction_rate, 0.0)
	
func constant_trauma(delta):
	if c_old_trauma > 0:
		c_old_trauma = max(c_old_trauma - delta * 2, 0.0)
		c_trauma = c_old_trauma
	else:
		c_trauma = max(c_trauma, 0.0)

func get_shake_intensity() -> float:
	return trauma * trauma

func get_c_shake_intensity() -> float:
	return c_trauma * c_trauma

func get_noise_from_seed(_seed: int) -> float:
	noise.seed = _seed
	return noise.get_noise_1d(shake_time * quick_noise_speed)

func get_c_noise_from_seed(_seed: int) -> float:
	noise.seed = _seed
	return noise.get_noise_1d(shake_time * c_noise_speed)
