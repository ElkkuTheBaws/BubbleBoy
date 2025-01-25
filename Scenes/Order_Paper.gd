extends Interactable
class_name OrderPapers
var order: Order

func set_order(_order: Order):
	order = _order
	var material = mesh.mesh.surface_get_material(0)
	material.albedo_texture = order.small_image
	mesh.mesh.surface_set_material(0, material)
	visible = true
	
func _ready() -> void:
	visible = false
	
func interact(item) -> void:
	print(order)
	Global.on_inspect.emit(order.detailed_image)
