extends Resource
class_name PlayerData

@export var budget: float = 1000.0
@export var days: int = 1
@export var is_intro_watched = false
@export var is_tutorial_watched = false
@export var expenses: float = 0.0
@export var profit: float = 0.0
@export var revenue: float = 0.0
@export var total_profit: float = 0.0
@export var inventory: Dictionary = {}
@export var selected_ingredients: Dictionary = {}  # Store selected ingredients
@export var dishes: Dictionary = {}
@export var dish_order: Array = []
@export var order: Dictionary = {}

@export var player_position: Vector2 = Vector2(136.0, 128.0)  # Example starting position

@export var goal_profit_per_day: float = 100.0  # You can change the number as needed

@export var music_volume: float = 1.0
@export var sfx_volume: float = 1.0



# Save the player data as a resource file
func save(file_path: String = "user://player_data.tres"):
	var error = ResourceSaver.save(self, file_path)
	if error != OK:
		print("❌ Failed to save PlayerData!")
	else:
		print("✅ PlayerData saved successfully.")

# Load player data from a resource file
static func load_data(file_path: String = "user://player_data.tres") -> PlayerData:
	if ResourceLoader.exists(file_path):
		return ResourceLoader.load(file_path) as PlayerData
	return PlayerData.new()  # Return default if file doesn't exist

func _return_selected_ingredients_to_inventory():
	for slot_id in selected_ingredients.keys():
		var ingredient = selected_ingredients[slot_id]
		print(ingredient, "123mictext")
		var item_name = ingredient.get("name")
		
		print(item_name, "123mictext")

		if not item_name.is_empty():
			if item_name in inventory:
				inventory[item_name]["quantity"] += ingredient.get("quantity")
			else:
				inventory[item_name] = {
					"name": ingredient.get("name"),
					"quantity": ingredient.get("quantity"),
					"price": ingredient.get("price"),
					"image": ingredient.get("image"),
				}

	# Clear selected ingredients
	selected_ingredients.clear()
	# **Force save to persist changes**
	save()
	
