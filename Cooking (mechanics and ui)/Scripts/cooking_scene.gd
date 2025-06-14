extends Control

@onready var ingredients: GridContainer = %Ingredients
@onready var ingredient_popup: PopupPanel = %IngredientPopup
@onready var ingredient: TextureButton = $PanelContainer/MarginContainer/Ingredients/IngredientSlot/Ingredient
@onready var cook_button: Button = %CookButton
@onready var output_label: Label = %OutputLabel
@onready var hidden_output_label: Label = %HiddenOutputLabel
@onready var output_rect: TextureRect = %OutputRect
@onready var notification_label: Label = $Notification


@onready var panel_container_3: PanelContainer = $PanelContainer3
@onready var timer: Timer = $Timer  # Make sure you have a Timer node in your scene

@onready var cook_timer: Timer = $CookTimer  # Make sure this exists in your scene!

var current_recipe: MenuItem = null  # Store the currently cooking dish


var player_data: PlayerData = PlayerData.load_data()
var selected_ingredients: Dictionary = {}




func _ready() -> void:
	MenuManager.load_recipes()
	if not output_rect.gui_input.is_connected(_on_output_rect_clicked):
		output_rect.gui_input.connect(_on_output_rect_clicked)
	
	# Connect to the customer_left signal from Orders node
	var orders_node = $Orders
	if orders_node:
		orders_node.customer_left.connect(_on_customer_left)
		

func _on_back_button_pressed() -> void:
	SoundEffects.play_click()
	SceneManager.return_to_game()



func select_ingredient(ingredient: Ingredient):
	if selected_ingredients.size() < 9:
		if ingredient.name in selected_ingredients:
			selected_ingredients[ingredient.name]["quantity"] += 1  # ✅ Always modify the dictionary
		else:
			selected_ingredients[ingredient.name] = {
				"image": ingredient.image,
				"name": ingredient.name,
				"price": ingredient.price,
				"quantity": 1  # ✅ Ensure correct structure
			}
		print("Added:", ingredient.name, "Total:", selected_ingredients[ingredient.name]["quantity"])
		
func remove_ingredient_by_name(name: String) -> void:
	if name in selected_ingredients:
		selected_ingredients[name]["quantity"] -= 1
		if selected_ingredients[name]["quantity"] <= 0:
			selected_ingredients.erase(name)
		print("Removed one", name, "Remaining:", selected_ingredients.get(name, {}))

func _on_cook_button_pressed() -> void:
	SoundEffects.play_click()
	if selected_ingredients.is_empty():
		_show_message("No ingredients selected!")
		return
	
	if current_recipe and current_recipe.is_cooking:
		_show_message("Already cooking a dish!")
		return  # Prevent multiple dishes from being cooked at the same time

	for recipe in MenuManager.recipes:
		var selected_counts = {}
		for key in selected_ingredients.keys():
			selected_counts[key] = selected_ingredients[key].get("quantity", 0)

		# Ensure ingredients match exactly (no extra or missing ones)
		if selected_counts != recipe.ingredients:
			continue  

		print(recipe.ingredients, "Cooking Recipe Found!")

		if _deduct_ingredients(recipe.ingredients):
			_start_cooking(recipe)
			_on_clear_button_pressed()
			hidden_output_label.text = recipe.name
			return
		else:
			_show_message("Not enough ingredients!")
			return

	_show_message("Invalid Recipe")
	selected_ingredients.clear()


func _deduct_ingredients(required_ingredients: Dictionary) -> bool:
	print("Before Deduction, Selected Ingredients:", selected_ingredients)
	print("Before Deduction, Player Inventory:", player_data.inventory)

	# First check if we have enough ingredients in both selected and inventory
	for ingredient_name in required_ingredients.keys():
		if ingredient_name not in selected_ingredients or selected_ingredients[ingredient_name].get("quantity", 0) < required_ingredients[ingredient_name]:
			print("Missing or insufficient:", ingredient_name)
			return false
		
		# Also check player's inventory
		if ingredient_name not in player_data.inventory or player_data.inventory[ingredient_name].get("quantity", 0) < required_ingredients[ingredient_name]:
			print("Missing or insufficient in inventory:", ingredient_name)
			return false

	# If we have enough, deduct from both selected_ingredients and player's inventory
	for ingredient_name in required_ingredients.keys():
		# Deduct from selected_ingredients
		selected_ingredients[ingredient_name]["quantity"] -= required_ingredients[ingredient_name]
		if selected_ingredients[ingredient_name]["quantity"] <= 0:
			selected_ingredients.erase(ingredient_name)
			
		# Deduct from player's inventory
		player_data.inventory[ingredient_name]["quantity"] -= required_ingredients[ingredient_name]
		if player_data.inventory[ingredient_name]["quantity"] <= 0:
			player_data.inventory.erase(ingredient_name)

	# Save changes to player data
	if selected_ingredients != player_data.selected_ingredients:
		player_data.selected_ingredients = selected_ingredients
		player_data.save()

	print("After Deduction, Selected Ingredients:", selected_ingredients)
	print("After Deduction, Player Inventory:", player_data.inventory)
	
	# Update the ingredient popup UI
	ingredient_popup.update_popup_ui()
	
	return true
	

func _start_cooking(recipe: MenuItem) -> void:
	# Start cooking process
	current_recipe = recipe
	current_recipe.is_cooking = true
	current_recipe.cooking_time_left = recipe.time_to_cooked

	# Show the panel while cooking
	panel_container_3.visible = true  

	# Disable clicking on the output while cooking
	output_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE  

	# Start the countdown timer (update every second)
	if cook_timer.is_stopped() == false:
		cook_timer.stop()

	cook_timer.wait_time = 1.0  # Tick every second
	cook_timer.one_shot = false  # Keep running until done
	cook_timer.start()

	# Initial countdown display
	output_label.text = "Cooking: " + recipe.label + " (" + str(recipe.time_to_cooked) + "s)"

func _on_cook_timer_timeout() -> void:
	if current_recipe and current_recipe.is_cooking:
		# Decrease remaining time
		current_recipe.cooking_time_left -= 1
		output_label.text = "Cooking: " + current_recipe.label + " (" + str(current_recipe.cooking_time_left) + "s)"

		# When cooking is done
		if current_recipe.cooking_time_left <= 0:
			_finish_cooking()


func _finish_cooking() -> void:
	if current_recipe:
		current_recipe.is_cooking = false
		current_recipe.cooking_time_left = 0
		cook_timer.stop()  # Stop countdown timer
		
		SoundEffects.play_doneCooking()

		# Enable clicking to collect dish
		output_rect.mouse_filter = Control.MOUSE_FILTER_STOP  


		_show_message(current_recipe.name + " is ready!")
		output_rect.texture = current_recipe.image  # Show cooked dish
		panel_container_3.visible = false  # Hide cooking panel

		player_data.save()
		current_recipe = null  # Reset cooking state


func _show_message(text: String) -> void:
	show_panel_for_seconds(1.5)
	output_label.text = text


func _on_clear_button_pressed() -> void:
	SoundEffects.play_click()
	player_data._return_selected_ingredients_to_inventory()
	# Reset all ingredient slots in the UI
	for slot in ingredients.get_children():
		var ingredient = slot.get_node("MarginContainer/Ingredient")
		if ingredient:
			selected_ingredients = {}  # ✅ Reset to an empty dictionary
			ingredient.reset_ingredient()
			
	# Update UI popup
	ingredient_popup.update_popup_ui()
	
signal dish_collected

func _on_output_rect_clicked(event: InputEvent):
	if not (event is InputEventMouseButton and event.pressed):
		return
	
	# ❌ Prevent clicking if no dish is ready
	if output_rect.texture == null:
		print("No dish to collect!")  # Debug message
		return
	
	# ❌ Prevent invalid collection attempts
	if hidden_output_label.text == "Invalid Recipe" or hidden_output_label.text == "No ingredients selected!":
		return

	var dish_name = hidden_output_label.text

	# ❌ Prevent collecting if still cooking
	if current_recipe and current_recipe.is_cooking:
		_show_message("Dish is still cooking! Please wait.")
		return

	# 🔍 Find the corresponding MenuItem (recipe)
	var cooked_recipe = MenuManager.recipes.filter(func(recipe): return recipe.name == dish_name).front() if MenuManager.recipes else null
	
	if cooked_recipe == null:
		print("Error: Recipe not found!")
		return

	# ✅ Save the dish details in player_data
	if dish_name in player_data.dishes:
		player_data.dishes[dish_name]["quantity"] += 1
	else:
		player_data.dishes[dish_name] = {
			"name": cooked_recipe.name,
			"label": cooked_recipe.label,
			"description": cooked_recipe.description,
			"price": cooked_recipe.price,
			"image": cooked_recipe.image,
			"ingredients": cooked_recipe.ingredients,
			"quantity": 1
		}
		
	emit_signal("dish_collected")

	# ✅ Clear output and disable clicking
	output_rect.texture = null
	output_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE  # Disable clicking

	print("Saved Dish:", player_data.dishes)
	player_data.save()

	
func show_panel_for_seconds(seconds: float):
	panel_container_3.visible = true  
	timer.wait_time = seconds  
	timer.start()  

	# ✅ Disconnect before reconnecting
	if timer.timeout.is_connected(_on_timer_timeout):
		timer.timeout.disconnect(_on_timer_timeout)

	timer.timeout.connect(_on_timer_timeout)

func _on_timer_timeout():
	panel_container_3.visible = false  # Hide the panel when timer runs out
	timer.timeout.disconnect(_on_timer_timeout)  # Disconnect to prevent multiple connections
	

func _on_customer_left(customer_name: String) -> void:
	# Show notification when a customer leaves
	notification_label.text = customer_name + " has left due to waiting too long!"
	notification_label.visible = true
	
	# Create a timer to hide the notification after 3 seconds
	var notification_timer = Timer.new()
	add_child(notification_timer)
	notification_timer.wait_time = 3.0
	notification_timer.one_shot = true
	notification_timer.timeout.connect(func(): 
		notification_label.visible = false
		notification_timer.queue_free()
	)
	notification_timer.start()

	
