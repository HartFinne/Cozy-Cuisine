extends PanelContainer

@onready var ingredient_label: Label = %IngredientLabel
@onready var price_label: Label = %PriceLabel
@onready var ingredient_rect: TextureRect = %IngredientRect

func set_ingredient_display(name: String, price: int, image: String):
	ingredient_label = %IngredientLabel
	price_label = %PriceLabel
	ingredient_rect = %IngredientRect
	
	
	ingredient_label.text = name
	price_label.text = str(price)

	# Load and set the texture
	var texture = load(image)
	if texture and ingredient_label:
		ingredient_rect.texture = texture
		ingredient_rect.custom_minimum_size = Vector2(100, 75)  # Adjust this as needed
		ingredient_label.custom_minimum_size = Vector2(120, 0)
	else:
		print("Error loading image:", image)
		ingredient_rect.texture = null

func _on_add_to_basket_button_pressed() -> void:
	print("oke")
	
	var basket_entry = {
		"name": ingredient_label.text,
		"price": price_label.text.to_int(),
		"image": ingredient_rect.texture.resource_path,
		"quantity": 1
	}
	
	BasketManager.add_to_basket(basket_entry)
