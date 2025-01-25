extends Resource
class_name Order

@export var small_image: CompressedTexture2D
@export var detailed_image: CompressedTexture2D

@export var requirements: Array[Global.IngredientType]
@export_category("Sentences")
@export var idle_sentence: Sentence
@export var positive_sentence: Sentence
@export var negative_sentence: Sentence
@export var hurt_sentence: Sentence

var completed: bool = false

#TODO: Fix this
func check_order(ingredient_list: Array) -> bool:
	for requirement in requirements:
		if not ingredient_list.has(requirement):
			return false
		var filtered = ingredient_list.filter(func(x): x != requirement)
		print(filtered)
	return true
