class_name Couldron extends Interactable 

@export var liquid: MeshInstance3D
@export var pot: Node3D
@export var audio: AudioStreamPlayer3D
@export var boilingAudio: AudioStreamPlayer3D
@export var bubble_particles: CPUParticles3D
@export_category("Sounds")
@export var splash_sounds: Array[AudioStreamWAV]
@export var pick_up_sound: AudioStreamWAV

var ingredients: Array[Global.IngredientType]
var amount: float = 1
var heat: float = 0:
	set(value):
		heat = clamp(value, 30, 100)
		var normalized = normalize(heat, 30, 100)
		boilingAudio.volume_db = linear_to_db(normalized * 0.4)
		bubble_particles.lifetime = clampf(normalized, 0.5, 1)
		liquid.material_override.set_shader_parameter("Displacement_Intensity",snappedf(normalized, 0.2))
		liquid.material_override.set_shader_parameter("Texture_Speed", snappedf(normalized, 0.2))

@export var spawn_pos: Node3D

func reset():
	ingredients = []
	amount = 1
	heat = 0
	bubble_particles.lifetime = 0.1

func interact(item):
	if item is Couldron:
		visible = true
		interactable_name = "Take pot"
		reset()
		bubble_particles.lifetime = 0.1
		interacted.emit(self)
		boilingAudio.play()
		play_audio(pick_up_sound)
	elif item is Ingredient:
		ingredients.append(item.type)
		add_to_pot(item)
		interacted.emit(item)
	elif item == null:
		interactable_name = "Place pot"
		visible = false
		interacted.emit(self)
		boilingAudio.stop()
		play_audio(pick_up_sound)

func play_audio(stream):
	audio.pitch_scale = randf_range(0.95, 1.05)
	audio.stream = stream
	audio.play()

func add_to_pot(item: Ingredient):
	var ingredient = item.hand_mesh.instantiate()
	add_child(ingredient)
	ingredient.position = spawn_pos.position
	var t: Tween = get_tree().create_tween()
	t.tween_property(ingredient, "position", Vector3(0, 0.1, 0), 0.5)
	t.tween_callback(func(): ingredient.queue_free())
	t.tween_callback(func(): play_audio(splash_sounds.pick_random()))

func normalize(value, min, max) -> float:
	return (value - min) / (max - min)

func _physics_process(delta: float) -> void:
	if visible:
		heat += delta * 8
		var normalized = normalize(heat, 30, 100) * 0.015
		pot.position.x = randf_range(-normalized, normalized)
		pot.position.z = randf_range(-normalized, normalized)
