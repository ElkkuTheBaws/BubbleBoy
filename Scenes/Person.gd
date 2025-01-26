class_name Person extends Interactable


@export var audio_player: AudioStreamPlayer3D
@export var customer_textures: Array[CompressedTexture2D]
@export var animation: AnimationPlayer
@export var target_node: Node3D
@export_category("Pizza girl")
@export var is_pizza_girl: bool = false
@export var pizza_mesh: MeshInstance3D
@export var customer: Node3D
@export var pizza: Node3D

@export var bowl_soup: Node3D

var max_side_angle: float = 90
# Accept order
# Refuse order
# And just order
@onready var collisionShape: CollisionShape3D = $CollisionShape3D
@onready var area: Area3D
var order: Order
var can_serve: bool = true
var can_dmg: bool = true

var damage_shake: float = 0
#var is_order_done: bool = false

func enable_person():
	visible = true
	collisionShape.disabled = false

func hide_person():
	visible = false
	collisionShape.disabled = true

func complete():
	await get_tree().create_timer(randf_range(30, 120)).timeout
	hide_person()
	order = null
	can_serve = false
	Global.gameManager.persons.append(self)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	init()

func init():
	pizza.visible = false
	hide_person()
	if is_pizza_girl:
		pizza.visible = true
		customer.visible = false
	
	var material: StandardMaterial3D = StandardMaterial3D.new()
	 #mesh.get_active_material(0)
	material.albedo_texture = customer_textures.pick_random()
	mesh.material_override = material
	#mesh.mesh.surface_set_material(0, material)
	#mesh.get_active_material(0).albedo_texture = customer_textures.pick_random()
	var animList = animation.get_animation_list()
	var index = randi_range(0, animList.size()-1)
	animation.current_animation = animList[index]

#func check_girl():
	#if is_pizza_girl:
		#pizza.visible = true
		#customer.visible = 
	#pizza.visible = false
	#hide_person()
	

func interact(item):
	if not audio_player.playing:
		if order != null:
			play_sentence(order.idle_sentence)

func set_order(_order: Order):
	order = null
	order = _order
	order._complete.connect(complete)
	if not order.completed:
		bowl_soup.visible = false

func damaged() -> void:
	if can_dmg:
		if order != null:
			play_sentence(order.hurt_sentence)
		can_dmg = false
		damage_shake = 0.1
		await get_tree().create_timer(2).timeout
		can_dmg = true
#func order_done():
	#is_order_done = true

func _on_area_3d_body_entered(body: Node3D) -> void:
	if visible:
		if body is Player:
			Global.current_person_area = self


func _on_area_3d_body_exited(body: Node3D) -> void:
	if visible:
		if self ==  Global.current_person_area:
			Global.current_person_area = null

func play_sentence(dialog: Sentence):
	if audio_player.playing:
		return
	audio_player.stop()
	if dialog.audio != null:
		audio_player.stream = dialog.audio
		audio_player.play()
		Global.start_dialog.emit(dialog.text, dialog.audio.get_length())
		await audio_player.finished
	#await get_tree().create_timer(2).timeout
	#Global.end_dialog.emit()

func _on_damage_area_body_entered(body: Node3D) -> void:
	if visible:
		if body is Player:
			Global.current_dmg_person_area = self


func _on_damage_area_body_exited(body: Node3D) -> void:
	if visible:
		if self ==  Global.current_dmg_person_area:
			Global.current_dmg_person_area = null

func _physics_process(delta: float) -> void:
	if damage_shake > 0:
		damage_shake -= delta * 0.2
		customer.position.x = randf_range(-damage_shake, damage_shake)
		customer.position.z = randf_range(-damage_shake, damage_shake)
		pizza.position.x = randf_range(-damage_shake, damage_shake)
		pizza.position.z = randf_range(-damage_shake, damage_shake)
	if can_serve:
		calculate_head_angle(delta)
	if is_pizza_girl:
		var node_forward = global_transform.basis.z.normalized()
		var target_position = Vector3(0, 0, 0)
		if Global.player_position != null:
			target_position = Global.player_position
		var direction = (target_position - global_position)
		direction.y = 0
		direction = direction.normalized()
		var angle_radians = node_forward.angle_to(direction) # - deg_to_rad(45) 
		var cross = node_forward.cross(direction)
		if cross.y < 0:
			angle_radians *= -1
		#angle_radians += deg_to_rad(90)
		pizza.rotation.y = lerp_angle(pizza.rotation.y, angle_radians, 6*delta)

func calculate_head_angle(delta):
	var node_forward = global_transform.basis.z.normalized()
	var target_position = Vector3(0, 0, 0)
	if Global.player_position != null:
		target_position = Global.player_position
	var direction = (target_position - global_position)
	direction.y = 0
	direction = direction.normalized()
	var angle_radians = node_forward.angle_to(direction) # - deg_to_rad(45) 
	var cross = node_forward.cross(direction)
	if cross.y < 0:
		angle_radians *= -1
	angle_radians += deg_to_rad(90)
	target_node.rotation.y = lerp_angle(target_node.rotation.y, clampf(angle_radians, deg_to_rad(-max_side_angle+90), deg_to_rad(max_side_angle+90)) , 6*delta)
