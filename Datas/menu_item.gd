extends Resource
class_name MenuItem

@export var name: String
@export var label: String
@export var description: String
@export var price: int
@export var image: Texture2D
@export var ingredients: Array[Ingredient]
@export var time_to_cooked: int  # Time required to cook (seconds)
var cooking_time_left: int = 0  # Time left to finish cooking
var is_cooking: bool = false  # Flag to track cooking state
