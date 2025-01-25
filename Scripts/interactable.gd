class_name Interactable extends StaticBody3D

@onready var highlight_material = preload("res://Assets/Shaders/outline_shader.tres")
@export var mesh: MeshInstance3D
signal interacted

@export var interactable_name: String = "Object"

func interact(item):
	pass

func highlight(value: bool):
	if value:
		mesh.material_overlay = highlight_material
	else:
		mesh.material_overlay = null
