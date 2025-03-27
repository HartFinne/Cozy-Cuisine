extends Resource
class_name Ingredient

@export var name: String
@export var image: Texture2D
@export var label: String
@export var price: int
@export var description: String


static func new_from_dict(data: Dictionary) -> Ingredient:
	var ingredient = Ingredient.new()
	ingredient.name = data.get("name", "")
	ingredient.price = data.get("price", 0)
	ingredient.image = data.get("image") if data.get("image") is Texture2D else null
	return ingredient
