extends Interactable
class_name Ingredient

@export var type: Global.IngredientType
@export var hand_mesh: Resource

func interact(item):
	if item == null:
		interacted.emit(self)
