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

var inspecting: bool = false

#@export var pot: Node3D
#var current_carry = null
var current_interaction: Interactable:
	set(object):
		if object != null:
			object.highlight(true)
			if object is Couldron and hands.curret_carry != null and hands.curret_carry is Ingredient:
					Global.on_interaction_hover.emit("Place ingredient")
			else:
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
	Global.on_inspect.connect(_on_inspect)

func _on_inspect(texture):
	inspecting = true

func _input(event):
	if inspecting:
		return
	if hands.curret_carry is Couldron:
		hands.move(event)
	else:
		look(event)

func look(event: InputEvent):
	#var inverted: float = -1.0 if Settings.inverted else 1.0
	rotate_y(inputComponent.getXRotation(event))
	headComponent.rotateHead(inputComponent.getYRotation(event))

func _physics_process(delta: float) -> void:
	if hands.curret_carry is Couldron:
		look_at_person(delta)
	inputComponent.setMovementInput()
	if not is_on_floor():
		velocity.y -= delta * 25
	if inspecting:
		return
	ground_move(delta)
	check_interaction()

func look_at_person(delta: float):
	var current_position = global_transform.origin
	var person = Global.gameManager.current_person
	if person != null:
		var direction = (person.global_position - current_position).normalized()
		direction.y = 0
		rotation.y= lerp(rotation.y,atan2(-direction.x,-direction.z),.03)
		headComponent.rotation.x = lerp(headComponent.rotation.x, deg_to_rad(-20.0), delta)

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
	if inspecting:
		Global.end_inspect.emit()
		inspecting = false
		return
	if current_interaction:
		current_interaction.interact(hands.curret_carry)


func _on_couldron_interacted(couldron) -> void:
	#if current_carry == null:
	if couldron != null:
		if couldron is Couldron:
			if not couldron.visible:
				hands.set_item(couldron)
			else:
				if hands.curret_carry is Pot:
					couldron.heat = hands.curret_carry.heat
				hands.remove_item()
		if couldron is Ingredient:
			if hands.curret_carry == couldron:
				hands.remove_item()


func _on_ingredient_interacted(ingredient) -> void:
	if hands.curret_carry == null:
		hands.set_item(ingredient)
