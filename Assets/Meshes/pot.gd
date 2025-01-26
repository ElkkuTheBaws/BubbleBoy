extends Node3D
class_name Pot
@export_range(0, 0.35) var default_liquid_height: float = 0.33
@export var liquid: Node3D
@export var audio: AudioStreamPlayer3D
@export var effectAudio: AudioStreamPlayer3D
@export var pour_sounds: Array[AudioStreamWAV]
@export var bubble_particles: CPUParticles3D
var ingredients = null

var heat: float = 0:
	set(value):
		heat = clamp(value, 30, 100)
		var normalized = normalize(heat, 30, 100)
		audio.volume_db = linear_to_db(normalized * 0.5)
		bubble_particles.lifetime = clampf(normalized, 0, 1)
		liquid.material_override.set_shader_parameter("Displacement_Intensity",snappedf(normalized, 0.2))
		liquid.material_override.set_shader_parameter("Texture_Speed", snappedf(normalized, 0.2))
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	liquid.position.y = default_liquid_height

func reset_pot() -> void:
	liquid.visible = true
	liquid.position.y = default_liquid_height
	bubble_particles.lifetime = 0

func set_amount(amount):
	var new_amount = amount * default_liquid_height
	liquid.position.y = new_amount
	liquid.visible = true

func _physics_process(delta: float) -> void:
	liquid.global_rotation = lerp(liquid.global_rotation, Vector3.ZERO + (global_rotation * 0.5), delta*4)
	var angle = normalize(liquid.position.y, 0, default_liquid_height) * 10
	if abs(global_rotation_degrees.x) > (40 + angle) or abs(global_rotation_degrees.z) > (40 + angle):
		if liquid.position.y > 0.15:
			liquid.position.y -= delta * 0.1
			liquid.visible = true
			check_pour()
			pour_sound()
		else:
			bubble_particles.lifetime = 0
			liquid.visible = false
			audio.stop()
			stop_pour()
	else:
		stop_pour()
	heat -= delta * 5
	var normalized = normalize(heat, 30, 100) * 0.015
	position.x = randf_range(-normalized, normalized)
	position.z = randf_range(-normalized, normalized)

func pour_sound():
	if not effectAudio.playing:
		effectAudio.stream = pour_sounds.pick_random()
		effectAudio.pitch_scale = randf_range(0.9, 1.1)
		effectAudio.play()

func stop_pour():
	effectAudio.stop()

func check_pour():
	if Global.current_dmg_person_area != null:
		var dmg_person = Global.current_dmg_person_area as Person
		if heat > 50:
			dmg_person.damaged() 
	if Global.current_person_area != null:
		var person = Global.current_person_area as Person
		if person.can_serve:
			#TODO: Problem with check_order
			if person.order.check_order(ingredients):
				Global.gameManager.order_done(person.order)
				print("Order done")
				person.can_serve = false
			else:
				print("Wrong order")
				person.can_serve = false
				await get_tree().create_timer(3).timeout
				person.can_serve = true

func normalize(value, min, max) -> float:
	return (value - min) / (max - min)
