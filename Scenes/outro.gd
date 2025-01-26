extends Node

@export var tex: TextureRect
@export_category("Scenes")
@export_group("First")
@export var images_1: Array[Texture2D]
@export_group("Second")
@export var images_2: Array[Texture2D]
@export_group("Third")
@export var images_3: Array[Texture2D]
@export_group("Fourth")
@export var images_4: Array[Texture2D]

var current_scene: int = 0

var frequency: float = 0.5
var freq_time: float = 0
var timer: float = 0

var ended: bool = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timer = 30

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("input_interaction"):
		change()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	timer -= delta
	if timer < 0:
		change()
	var new_images = get_current_scene_images()
	freq_time += delta
	if freq_time > frequency:
		tex = new_images.pick_random()

func get_current_scene_images() -> Array[Texture2D]:
	match current_scene:
		0:
			return images_1
		1:
			return images_2
		2:
			return images_3
		_:
			return images_4
			
func change():
	if current_scene < 4:
		current_scene += 1
		timer = 30
	else:
		if not ended:
			ended = true
			await get_tree().create_timer(1).timeout
			SceneTransition.change_scene("res://Scenes/MainMenu.tscn")
