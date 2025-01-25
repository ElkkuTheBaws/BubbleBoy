class_name Couldron extends Interactable 

var ingredients: Array[Global.IngredientType]
@export var spawn_pos: Node3D

func reset():
	ingredients = []

func interact(item):
	if item is Couldron:
		visible = true
		interactable_name = "Take pot"
		reset()
		interacted.emit(null)
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
