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

@export_category("Carrying")
@export var interact_raycast: RayCast3D
@export var hands: Hands
#@export var pot: Node3D
#var current_carry = null
var current_interaction: Interactable:
	set(object):
		if object != null:
			object.highlight(true)
			Global.on_interaction_hover.emit(object.interactable_name)
		else:
			if current_interaction != null:
				current_interaction.highlight(false)
			Global.on_interaction_hover.emit(null)
		current_interaction = object
#var carrying: bool = false
func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	inputComponent.connect("interact_action", interact)

func _input(event):
	if hands.curret_carry is Couldron:
		hands.move(event)
	else:
		look(event)

func look(event: InputEvent):
	#var inverted: float = -1.0 if Settings.inverted else 1.0
	rotate_y(inputComponent.getXRotation(event))
	headComponent.rotateHead(inputComponent.getYRotation(event))

func _physics_process(delta: float) -> void:
	inputComponent.setMovementInput()
	if not is_on_floor():
		velocity.y -= delta * 25
	ground_move(delta)
	check_interaction()
	
func ground_move(delta: float) -> void:
	var direction: Vector3 = (global_transform.basis.x * inputComponent.input_dir.x + global_transform.basis.z * inputComponent.input_dir.y).normalized()
	var calculatedVelocity = getGroundVelocity(velocity, direction, delta, walk_speed)
	# Apply velocity and movement
	velocity = calculatedVelocity
	move_and_slide()
	# Apply headbob
	headComponent.applyGroundHeadBob(direction, delta)
	headComponent.calculate_side_sway(velocity, delta)
	hands.velocity = velocity

func getGroundVelocity(velocity: Vector3, direction: Vector3, delta: float, speed: float = 10) -> Vector3:
	if direction != Vector3.ZERO:
		velocity = velocity.lerp(direction * speed, delta*acceleration)
	else:
		velocity = velocity.lerp(Vector3.ZERO, delta*deacceleration)
	return velocity

func check_interaction():
	current_interaction = null
	if interact_raycast.is_colliding():
		var collider = interact_raycast.get_collider()
		if collider is Interactable:
			current_interaction = collider

func interact():
	if current_interaction:
		current_interaction.interact(hands.curret_carry)


func _on_couldron_interacted(couldron) -> void:
	#if current_carry == null:
	if couldron != null:
		if couldron is Couldron:
			print("HELLO")
			hands.set_item(couldron)
		if couldron is Ingredient:
			if hands.curret_carry == couldron:
				hands.remove_item()
	elif couldron == null:
		hands.remove_item()


func _on_ingredient_interacted(ingredient) -> void:
	if hands.curret_carry == null:
		hands.set_item(ingredient)
