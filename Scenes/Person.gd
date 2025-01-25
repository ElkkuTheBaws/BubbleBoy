class_name Person extends Interactable


# Accept order
# Refuse order
# And just order
@onready var collisionShape: CollisionShape3D = $CollisionShape3D
@onready var area: Area3D
var order: Order
var can_serve: bool = true
#var is_order_done: bool = false

func enable_person():
	visible = true
	collisionShape.disabled = false

func hide_person():
	visible = false
	collisionShape.disabled = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide_person()

#func order_done():
	#is_order_done = true

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body is Player:
		Global.current_person_area = self


func _on_area_3d_body_exited(body: Node3D) -> void:
	if self ==  Global.current_person_area:
		Global.current_person_area = null

func play_sentence(dialog: Sentence):
	audio_player.stream = dialog.audio
	audio_player.volume_db = -20
	audio_player.play()
	print(dialog.audio)
	Global.start_dialog.emit(dialog.text, dialog.audio.get_length())
	await audio_player.finished
	await get_tree().create_timer(2).timeout
	Global.end_dialog.emit()
