extends Interactable

@export var audio: AudioStreamPlayer3D
@export var phone_node: Node3D
var calling: bool = false
var time: float = 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	time = randf_range(30, 50)


func _physics_process(delta: float) -> void:
	time -= delta
	if time < 0:
		time = randf_range(30, 50)
		start_call()
	if calling:
		phone_node.position.x = randf_range(-0.015, 0.015)
		phone_node.position.z = randf_range(-0.015, 0.015)

func start_call():
	calling = true
	audio.play()

func interact(item):
	calling = false
	audio.stop()
