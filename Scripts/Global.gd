extends Node

@export var paused: bool = false
var current_person_area = null
var current_dmg_person_area = null
var gameManager: GameManager
var player_position: Vector3 = Vector3.ZERO
signal on_interaction_hover(item)
signal on_inspect(image)
signal end_inspect
signal start_dialog(text: String, time: float)
enum IngredientType {tomato, onion, sandal, mushroom, beans, beer, burger, fish, nails, potatoes}
