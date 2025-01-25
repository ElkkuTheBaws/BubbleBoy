extends Node3D
class_name Pot
@export_range(0, 0.35) var default_liquid_height: float = 0.33
@export var liquid: Node3D
var heat: float = 0:
	set(value):
		heat = clamp(value, 30, 100)
		var normalized = normalize(heat, 30, 100)
		liquid.material_override.set_shader_parameter("Displacement_Intensity",snappedf(normalized, 0.2))
		liquid.material_override.set_shader_parameter("Texture_Speed", snappedf(normalized, 0.2))
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	liquid.position.y = default_liquid_height

func reset_pot() -> void:
	liquid.visible = true
	liquid.position.y = default_liquid_height

func set_amount(amount):
	var new_amount = amount * 0.33
	print("New amount: " + str(new_amount))
	liquid.position.y = new_amount

func _physics_process(delta: float) -> void:
	liquid.global_rotation = lerp(liquid.global_rotation, Vector3.ZERO + (global_rotation * 0.5), delta*4)
	var angle = normalize(liquid.position.y, 0, default_liquid_height) * 10
	if abs(global_rotation_degrees.x) > (40 + angle) or abs(global_rotation_degrees.z) > (40 + angle):
		if liquid.position.y > 0.15:
			liquid.position.y -= delta * 0.1
			liquid.visible = true
		else:
			liquid.visible = false
	heat -= delta * 5
	var normalized = normalize(heat, 30, 100) * 0.015
	position.x = randf_range(-normalized, normalized)
	position.z = randf_range(-normalized, normalized)

func normalize(value, min, max) -> float:
	return (value - min) / (max - min)
