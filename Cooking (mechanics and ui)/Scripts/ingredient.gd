extends TextureButton

@onready var ingredient_popup: PopupPanel = %IngredientPopup

signal ingredient_selected(ingredient)
var ingredient_data: Dictionary  # Store ingredient data
var previous_ingredient: Dictionary  # Store previous ingredient data

var player_data: PlayerData = PlayerData.load_data()
var ingredient_slot_id: String  # Unique ID for this button slot
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	connect("pressed", _on_ingredient_clicked)
	
	# Listen for ingredient selection from popup
	ingredient_popup.connect("ingredient_selected", Callable(self, "_on_ingredient_selected"))
	
	# use to return the selected ingredients to the inventory
	player_data._return_selected_ingredients_to_inventory()
	
	
	
func _on_ingredient_clicked():
	if ingredient_popup:
		ingredient_popup.show_popup(self)  # Pass this ingredient slot
		# print(self)
		
func _on_ingredient_selected(new_ingredient_data: Dictionary):
	print("Received ingredient:", new_ingredient_data)
	
	print(ingredient_data, ingredient_data.has(name), "working sans")

	# If there's a previously selected ingredient, add it back to inventory
	if ingredient_data and ingredient_data.has("name"):
		_return_previous_ingredient_to_inventory()

	# Update the button texture
	texture_normal = new_ingredient_data.get("image")

	# Remove selected ingredient from inventory
	var item_name = new_ingredient_data.get("name")
	if item_name in player_data.inventory:
		player_data.inventory[item_name]["quantity"] -= 1
		if player_data.inventory[item_name]["quantity"] <= 0:
			player_data.inventory.erase(item_name)

	ingredient_data = new_ingredient_data
	player_data.selected_ingredients[new_ingredient_data.get("name")] = new_ingredient_data
	
	print(player_data.selected_ingredients, "workings")
	player_data.save()

	# Refresh popup UI
	ingredient_popup.update_popup_ui()
		
func _return_previous_ingredient_to_inventory():
	if ingredient_data and ingredient_data.has("name"):
		var item_name = ingredient_data.get("name")
		if not item_name.is_empty():
			if item_name in player_data.inventory:
				player_data.inventory[item_name]["quantity"] += 1
			else:
				player_data.inventory[item_name] = {
					"name": ingredient_data.get("name"),
					"quantity": 1,
					"price": ingredient_data.get("price"),
					"image": ingredient_data.get("image"),
				}

	# Save inventory update after returning previous ingredient
	player_data.save()
