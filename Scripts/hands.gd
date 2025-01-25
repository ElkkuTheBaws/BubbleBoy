extends Node3D
class_name Hands


@export var input: PlayerInputComponent
#@export var liquid: Node3D
@export_category("Sway")
@export var swaySpeed: float = 10
@export var swayAngle: float = 90
@export_category("Carry_meshes")
@export var pot: Pot
@export var hand: Node3D

var curret_carry = null
var velocity: Vector3 = Vector3.ZERO
var acceleration: float = 10
var old_velocity: Vector3
		

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pot.visible = false
	hand.visible = false

func remove_item():
	pot.visible = false
	hand.visible = false
	if curret_carry != null:
		if curret_carry is Ingredient:
			remove_ingredient()
		curret_carry = null

func set_item(item):
	pot.visible = false
	hand.visible = false
	if item != null:
		if item is Couldron:
			pot.visible = true
			pot.global_position = item.global_position
			pot.set_amount(item.amount)
			pot.heat = item.heat
			var t: Tween = get_tree().create_tween()
			t.tween_property(pot, "position", Vector3.ZERO, 0.2)
		elif item is Ingredient:
			hand.visible = true
			set_ingredient(item.hand_mesh)
		curret_carry = item
		rotation_degrees = Vector3.ZERO

func remove_ingredient():
	var child = hand.get_child(0)
	child.queue_free()
	hand.visible = false

func set_ingredient(mesh: Resource):
	var ingredient = mesh.instantiate()
	hand.add_child(ingredient)
	hand.visible = true

func _physics_process(delta: float) -> void:
		calculate_sway(velocity, delta)
		#rotation_degrees.z = clampf(rotation_degrees.z, -swayAngle, swayAngle)
		#rotation_degrees.x = clampf(rotation_degrees.x, -swayAngle, swayAngle)
		
		rotation_degrees.y = 0
		

func move(event: InputEvent):
		rotation.z += input.getXRotation(event) * swaySpeed
		rotation.x += input.getYRotation(event) * swaySpeed
		
func calculate_sway(vel: Vector3, delta: float):
	var speed: float = delta * swaySpeed
	# Calculate sway angles
	var side_sway: float = vel.dot(-global_transform.basis.x) * swayAngle
	var forward_sway: float = vel.dot(global_transform.basis.z) * swayAngle
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
	side_sway = clampf(side_sway, -swayAngle, swayAngle)
	forward_sway = clampf(forward_sway, -swayAngle, swayAngle)
	rotation_degrees.z = lerp(rotation_degrees.z, side_sway, speed)
	rotation_degrees.x = lerp(rotation_degrees.x, forward_sway, speed)
	
