class_name Couldron extends Interactable 

var has_couldron: bool = true

func interact(item):
	if has_couldron:
		has_couldron = false
		mesh.visible = false
		interactable_name = "Place pot"
	else:
		interactable_name = "Take pot"
		has_couldron = true
		mesh.visible = true
	interacted.emit(global_position)
