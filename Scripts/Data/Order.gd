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

#TODO: Fix this BIG TIME
func check_order(ingredient_list) -> bool:
	if len(ingredient_list) != len(requirements):
		print("yesyes")
		return false
	# Sort the lists and compare
	ingredient_list.sort()
	requirements.sort()
	print(ingredient_list)
	print(requirements)
	print(ingredient_list == requirements)
	return ingredient_list == requirements
