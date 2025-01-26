extends AudioStreamPlayer3D

@export var musics: Array[AudioStreamOggVorbis]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	stream = musics.pick_random()
	play()
	finished.connect(_ended)
	
func _ended():
	stream = musics.pick_random()
	play()
