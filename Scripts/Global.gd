extends Node

@export var paused: bool = false
var current_person_area = null
var gameManager: GameManager
signal on_interaction_hover(item)
signal on_inspect(image)
signal end_inspect

enum IngredientType {tomato, onion, sandal, mushroom, beans, random, beer}
