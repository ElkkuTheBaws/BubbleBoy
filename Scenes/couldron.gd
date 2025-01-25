class_name Couldron extends Interactable 

@export var liquid: MeshInstance3D
@export var pot: Node3D
var ingredients: Array[Global.IngredientType]
var amount: float = 1
var heat: float = 0:
	set(value):
		heat = clamp(value, 30, 100)
		var normalized = normalize(heat, 30, 100)
		liquid.material_override.set_shader_parameter("Displacement_Intensity",snappedf(normalized, 0.2))
		liquid.material_override.set_shader_parameter("Texture_Speed", snappedf(normalized, 0.2))
		print("HEat: " + str(heat))
		print(normalized)
@export var spawn_pos: Node3D

func reset():
	ingredients = []
	amount = 1

func interact(item):
	if item is Couldron:
		visible = true
		interactable_name = "Take pot"
		reset()
		interacted.emit(self)
	elif item is Ingredient:
		ingredients.append(item.type)
		add_to_pot(item)
		interacted.emit(item)
	elif item == null:
		visible = false
		interacted.emit(self)

func add_to_pot(item: Ingredient):
	var ingredient = item.hand_mesh.instantiate()
	add_child(ingredient)
	ingredient.position = spawn_pos.position
	var t: Tween = get_tree().create_tween()
	t.tween_property(ingredient, "position", Vector3(0, 0.1, 0), 0.5)
	t.tween_callback(func(): ingredient.queue_free())

func normalize(value, min, max) -> float:
	return (value - min) / (max - min)

func _physics_process(delta: float) -> void:
	if visible:
		heat += delta * 8
		var normalized = normalize(heat, 30, 100) * 0.015
		pot.position.x = randf_range(-normalized, normalized)
		pot.position.z = randf_range(-normalized, normalized)
