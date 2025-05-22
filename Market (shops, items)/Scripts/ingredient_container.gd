extends PanelContainer

@onready var ingredient_label: Label = %IngredientLabel
@onready var price_label: Label = %PriceLabel
@onready var ingredient_rect: TextureRect = %IngredientRect
@onready var indicator_label: Label = %IndicatorLabel

var basket: Basket = Basket.load_basket()
var ingredient_resource: Ingredient  # Store the ingredient resource

func _ready() -> void:
	if basket:
		basket.basket_updated.connect(update_indicator)

func set_ingredient_display(ingredient: Ingredient):
	ingredient_label = %IngredientLabel
	price_label = %PriceLabel
	ingredient_rect = %IngredientRect
	ingredient_resource = ingredient  # Store the resource for later use
	indicator_label = %IndicatorLabel
	
	
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
		
	update_indicator()


func _on_add_to_basket_button_pressed() -> void:
	SoundEffects.play_click()
	print("Added to basket:", ingredient_resource.name)

	# Add ingredient to basket resource
	basket.add_item(ingredient_resource, 1)
	basket.save_basket()  # Save changes

	# Debugging output
	print("Current Basket:", basket.items)
	
		
func update_indicator():
	var item_data = basket.items.get(ingredient_resource.name)
	var item_count = item_data["quantity"] if item_data else 0
	
	if item_count > 0:
		indicator_label.text = "+%d" % item_count
		indicator_label.visible = true
	else:
		indicator_label.visible = false
