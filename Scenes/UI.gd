extends Control

@export var label: Label
@export var texture: TextureRect

@export_category("Dialog")
@export var dialog_label: Label
@export var dialog_timer: Timer
#var current_dialog: String
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.on_interaction_hover.connect(show_interact)
	Global.on_inspect.connect(inspecting)
	Global.end_inspect.connect(stop_inspecting)
	texture.visible = false
	Global.start_dialog.connect(add_text)
	dialog_timer.timeout.connect(reset_dialog_stuff)
	
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

func add_text(_text: String, time: float):
	dialog_timer.stop()
	dialog_label.text = _text
	dialog_label.visible_ratio = 0
	dialog_label.material.set_shader_parameter("shakeAmount", 100)
	var t: Tween = get_tree().create_tween()
	t.tween_property(dialog_label, "visible_ratio", 1, time)
	t.tween_callback(dialog_end)
	dialog_label.material.set_shader_parameter("shakeAmount", 1)

func dialog_end():
	dialog_timer.start()

func reset_dialog_stuff():
	dialog_label.text = ""
	dialog_label.material.set_shader_parameter("shakeAmount", 100)

func clear_text():
	dialog_label.text = ""
