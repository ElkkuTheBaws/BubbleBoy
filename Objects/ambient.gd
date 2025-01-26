extends AudioStreamPlayer3D

@export var sounds: Array[AudioStream]

var time: float = 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	time = randf_range(30, 50)

func play_sound():
	global_position = Vector3(randf_range(-20, 20), 0, randf_range(-20, 20))
	time = randf_range(30, 50)
	stream = sounds.pick_random()
	pitch_scale = randf_range(0.9, 1.1)
	play()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	time -= delta
	if time < 0:
		play_sound()
