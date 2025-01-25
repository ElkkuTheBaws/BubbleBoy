extends Control

@export var label: Label
@export var texture: TextureRect

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.on_interaction_hover.connect(show_interact)
	Global.on_inspect.connect(inspecting)
	Global.end_inspect.connect(stop_inspecting)
	texture.visible = false

func show_interact(value):
	if value != null:
		label.text = value
		label.visible = true
	else:
		label.visible = false

func inspecting(_texture):
	texture.texture = _texture
	texture.visible = true

func stop_inspecting():
	print("Stop inspection")
	texture.visible = false
