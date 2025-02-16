extends Resource
class_name Order

@export var girl: bool = false
@export var final_order: bool = false
@export var small_image: CompressedTexture2D
@export var detailed_image: CompressedTexture2D

@export var requirements: Array[Global.IngredientType]
@export_category("Sentences")
@export var idle_sentence: Sentence
@export var positive_sentence: Sentence
@export var negative_sentence: Sentence
@export var hurt_sentence: Sentence

signal _complete()

var completed: bool = false


#TODO: Fix this BIG TIME
func check_order(ingredient_list) -> bool:
	if final_order:
		return true
	if len(ingredient_list) != len(requirements):
		return false
	# Sort the lists and compare
	ingredient_list.sort()
	requirements.sort()
	return ingredient_list == requirements
