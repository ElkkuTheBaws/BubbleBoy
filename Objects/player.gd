extends CharacterBody3D
class_name Player

@export_category("Components")
@export var headComponent: PlayerHeadComponent
@export var inputComponent: PlayerInputComponent
@export_category("Acceleration")
@export_range(0, 20) var acceleration: float = 10
@export_range(0, 20) var deacceleration: float = 10
@export_category("Movement speed")
@export_range(0,40) var walk_speed: float = 30

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _input(event):
	look(event)

func look(event: InputEvent):
	#var inverted: float = -1.0 if Settings.inverted else 1.0
	rotate_y(inputComponent.getXRotation(event))
	headComponent.rotateHead(inputComponent.getYRotation(event))

func _physics_process(delta: float) -> void:
	inputComponent.setMovementInput()
	ground_move(delta)
	
func ground_move(delta: float) -> void:
	var direction: Vector3 = (global_transform.basis.x * inputComponent.input_dir.x + global_transform.basis.z * inputComponent.input_dir.y).normalized()
	var calculatedVelocity = getGroundVelocity(velocity, direction, delta, walk_speed)
	# Apply velocity and movement
	velocity = calculatedVelocity
	move_and_slide()
	# Apply headbob
	headComponent.applyGroundHeadBob(direction, delta)
	headComponent.calculate_side_sway(velocity, delta)

func getGroundVelocity(velocity: Vector3, direction: Vector3, delta: float, speed: float = 10) -> Vector3:
	if direction != Vector3.ZERO:
		velocity = velocity.lerp(direction * speed, delta*acceleration)
	else:
		velocity = velocity.lerp(Vector3.ZERO, delta*deacceleration)
	return velocity
