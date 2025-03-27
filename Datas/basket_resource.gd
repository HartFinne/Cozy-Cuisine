extends Resource
class_name Basket

@export var items: Dictionary  # Stores items in the basket
signal basket_updated

# Add an ingredient to the basket
func add_item(ingredient: Ingredient, quantity: int):
	print("working add item")
	if ingredient.name in items:
		items[ingredient.name]["quantity"] += quantity  # Increase quantity if item exists
	else:
		items[ingredient.name] = {
			"image": ingredient.image,
			"name": ingredient.name,
			"price": ingredient.price,
			"quantity": quantity
		}
	basket_updated.emit()
	
# Subtract an ingredient from the basket
func subtract_item(ingredient_name: String, quantity: int):
	if ingredient_name in items:
		items[ingredient_name]["quantity"] -= quantity  # Decrease quantity
		if items[ingredient_name]["quantity"] <= 0:
			items.erase(ingredient_name)  # Remove if quantity reaches 0
		
	basket_updated.emit()  # Notify UI

# Remove an ingredient from the basket
func remove_item(ingredient_name: String):
	if ingredient_name in items:
		items.erase(ingredient_name)  # Completely remove item from dictionary
		basket_updated.emit()  # Notify UI

# Get the total cost of all items in the basket
func get_total_price() -> float:
	var total: float = 0
	for item in items.values():
		total += item["price"] * item["quantity"]
	return total

# Save the basket to a file (for persistence)
func save_basket(file_path: String = "user://basket.tres"):
	ResourceSaver.save(self, file_path)

# Load the basket from a file
static func load_basket(file_path: String = "user://basket.tres") -> Basket:
	if ResourceLoader.exists(file_path):
		return ResourceLoader.load(file_path) as Basket
	return Basket.new()  # Return a new empty basket if file doesn't exist
