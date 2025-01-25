extends Control

@export var label: Label

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.on_interaction_hover.connect(show_interact)


func show_interact(value):
	if value != null:
		label.text = value
		label.visible = true
	else:
		label.visible = false
