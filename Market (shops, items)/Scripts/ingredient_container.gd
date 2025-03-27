extends PanelContainer

@onready var ingredient_label: Label = %IngredientLabel
@onready var price_label: Label = %PriceLabel
@onready var ingredient_rect: TextureRect = %IngredientRect

@onready var basket: Basket = Basket.load_basket()
var ingredient_resource: Ingredient  # Store the ingredient resource

signal basket_updated

func set_ingredient_display(ingredient: Ingredient):
	ingredient_label = %IngredientLabel
	price_label = %PriceLabel
	ingredient_rect = %IngredientRect
	ingredient_resource = ingredient  # Store the resource for later use
	
	
	ingredient_label.text = ingredient.name
	price_label.text = str(ingredient.price)

	# Load and set the texture from Ingredient resource
	if ingredient.image:
		ingredient_rect.texture = ingredient.image
		ingredient_rect.custom_minimum_size = Vector2(100, 75)  # Adjust if needed
		ingredient_label.custom_minimum_size = Vector2(120, 0)
	else:
		print("Error: Ingredient has no image")
		ingredient_rect.texture = null

func _on_add_to_basket_button_pressed() -> void:
	print("Added to basket:", ingredient_resource.name)

	# Add ingredient to basket resource
	basket.add_item(ingredient_resource, 1)
	basket.save_basket()  # Save changes

	# Debugging output
	print("Current Basket:", basket.items)
