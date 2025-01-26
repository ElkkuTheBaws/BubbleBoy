extends Interactable
class_name OrderPapers
var order: Order

func set_order(_order: Order):
	order = _order
	var material: StandardMaterial3D = StandardMaterial3D.new()
	#var material = mesh.mesh.surface_get_material(0)
	material.albedo_texture = order.small_image
	mesh.material_override = material
	#mesh.mesh.surface_set_material(0, material)
	set_collision_layer_value(4, true)
	visible = true
	
func _ready() -> void:
	visible = false
	set_collision_layer_value(4, false)
	
func interact(item) -> void:
	print(order)
	Global.on_inspect.emit(order.detailed_image)
