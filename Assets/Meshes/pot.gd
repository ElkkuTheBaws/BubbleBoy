extends Node3D

@export_range(0, 0.35) var default_liquid_height: float = 0.33
@export var liquid: Node3D
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	liquid.position.y = default_liquid_height

func reset_pot() -> void:
	liquid.visible = true
	liquid.position.y = default_liquid_height

func _physics_process(delta: float) -> void:
	liquid.global_rotation = lerp(liquid.global_rotation, Vector3.ZERO + (global_rotation * 0.5), delta*4)
	var angle = normalize(liquid.position.y, 0, 0.33) * 10
	if abs(global_rotation_degrees.x) > (40 + angle) or abs(global_rotation_degrees.z) > (40 + angle):
		if liquid.position.y > 0.15:
			liquid.position.y -= delta * 0.1
			liquid.visible = true
		else:
			liquid.visible = false

func normalize(value, min, max) -> float:
	return (value - min) / (max - min)
