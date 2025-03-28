extends Control

@onready var ingredients: GridContainer = %Ingredients
@onready var ingredient_popup: PopupPanel = %IngredientPopup
@onready var ingredient: TextureButton = $PanelContainer/MarginContainer/Ingredients/IngredientSlot/Ingredient
@onready var cook_button: Button = %CookButton
@onready var output_label: Label = %OutputLabel
@onready var output_rect: TextureRect = %OutputRect

@onready var panel_container_3: PanelContainer = $PanelContainer3
@onready var timer: Timer = $Timer  # Make sure you have a Timer node in your scene

var player_data: PlayerData = PlayerData.load_data()
var selected_ingredients: Array[Ingredient] = []  # Store Ingredient objects
var recipes: Array[MenuItem] = []  # Holds loaded RecipeData resources

func _ready() -> void:
	load_recipes()

func load_recipes():
	var recipe_files = [
		"res://Datas/Resources/MenuItems/BurgerSteak.tres"
	]
	
	for path in recipe_files:
		var recipe = load(path) as MenuItem
		if recipe:
			recipes.append(recipe)
			print("Loaded Recipe - Ingredients:", recipe.ingredients, "Result:", recipe.name)


func select_ingredient(ingredient_name: Ingredient):
	
	if selected_ingredients.size() < 9:
		selected_ingredients.append(ingredient_name)
		print("Added:", ingredient_name)

func _on_cook_button_pressed() -> void:
	print(selected_ingredients)
	if selected_ingredients.is_empty():
		show_panel_for_seconds(1.5)
		output_label.text = "No ingredients selected!"
		return
	
	# Convert selected ingredients to names for comparison
	var selected_names = selected_ingredients.map(func(i): return i.name)
	selected_names.sort()

	for recipe in recipes:
		var recipe_names = recipe.ingredients.map(func(i): return i.name)
		recipe_names.sort()

		if selected_names == recipe_names:
			output_label.text = recipe.name
			output_rect.texture = recipe.image  # Ensure `image` is in MenuItem
			selected_ingredients.clear()
			return

	show_panel_for_seconds(1.5)
	output_label.text = "Invalid Recipe"
	selected_ingredients.clear()


func _on_clear_button_pressed() -> void:
	player_data._return_selected_ingredients_to_inventory()
	# Reset all ingredient slots in the UI
	for slot in ingredients.get_children():
		var ingredient = slot.get_node("Ingredient")
		if ingredient:
			selected_ingredients = []
			ingredient.reset_ingredient()
			
			
	# since we create variable that have the popup node kasama na rin dun yung script so we can call the 
	# function of it
	ingredient_popup.update_popup_ui()
	
	
func show_panel_for_seconds(seconds: float):
	panel_container_3.visible = true  # Show the panel
	timer.wait_time = seconds  # Set the wait time
	timer.start()  # Start the timer
	timer.timeout.connect(_on_timer_timeout)  # Connect signal to function

func _on_timer_timeout():
	panel_container_3.visible = false  # Hide the panel when timer runs out
	timer.timeout.disconnect(_on_timer_timeout)  # Disconnect to prevent multiple connections
	
