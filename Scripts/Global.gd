extends Node

@export var paused: bool = false

signal on_interaction_hover(item)

enum IngredientType {tomato, onion, sandal, mushroom, beans, random, beer}
