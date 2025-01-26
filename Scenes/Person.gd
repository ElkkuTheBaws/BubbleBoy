class_name Person extends Interactable

@export var audio_player: AudioStreamPlayer3D
@export var customer_textures: Array[CompressedTexture2D]
@export var animation: AnimationPlayer
@export var target_node: Node3D
var max_side_angle: float = 90
# Accept order
# Refuse order
# And just order
@onready var collisionShape: CollisionShape3D = $CollisionShape3D
@onready var area: Area3D
var order: Order
var can_serve: bool = true
var can_dmg: bool = true
#var is_order_done: bool = false

func enable_person():
	visible = true
	collisionShape.disabled = false

func hide_person():
	visible = false
	collisionShape.disabled = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide_person()
	mesh.get_active_material(0).albedo_texture = customer_textures.pick_random()
	var animList = animation.get_animation_list()
	var index = randi_range(0, animList.size()-1)
	animation.current_animation = animList[index]

func set_order(_order: Order):
	order = null
	order = _order

func damaged() -> void:
	if can_dmg:
		print("Damaged")
		can_dmg = false
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
	audio_player.stream = dialog.audio
	#audio_player.volume_db = -20
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
	if can_serve:
		calculate_head_angle(delta)

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
