extends Node3D
class_name GameManager
@export var persons: Array[Person]
@export var orders: Array[Order]
@export var order_papers: Array[OrderPapers]
var current_order: int = 0

var current_person = null
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	person_appear()
	Global.gameManager = self

func person_appear():
	#var filtered_list = persons.filter(func(x): return x if current_persons.has(x))
	var order = orders[current_order]
	var person: Person = persons.pick_random() as Person
	person.set_order(order)
	order_papers[current_order].set_order(order)
	persons.erase(person)
	person.enable_person()
	current_person = person

func order_done(order: Order):
	order.completed = true
	current_order += 1
	person_appear()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
