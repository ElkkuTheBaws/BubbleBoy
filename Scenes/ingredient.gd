extends Interactable
class_name Ingredient

@export var type: Global.IngredientType
@export var hand_mesh: Resource
@export var audio: AudioStreamPlayer3D

func interact(item):
	if item == null:
		interacted.emit(self)
		audio.play()
