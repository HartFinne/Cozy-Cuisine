extends PanelContainer
@onready var ingredient_label: Label = %IngredientLabel
@onready var price_label: Label = %PriceLabel
@onready var quantity_label: Label = %QuantityLabel
@onready var ingredient_rect: TextureRect = %IngredientRect

func set_ingredient_data(ingredient: Dictionary):
	ingredient_label = %IngredientLabel
	price_label = %PriceLabel
	quantity_label = %QuantityLabel
	ingredient_rect = %IngredientRect
	print(ingredient)
	
	ingredient_rect.texture = ingredient.get("image")
	ingredient_label.text = "Name: " + ingredient.get("name", "Unknown")
	price_label.text = "Price: " + str(ingredient.get("price", 0))  # Display price with currency
	quantity_label.text = "Quantity: " + str(ingredient.get("quantity", 0))  # Show quantity
