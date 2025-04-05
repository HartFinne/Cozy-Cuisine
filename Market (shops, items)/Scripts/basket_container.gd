extends PanelContainer

@onready var ingredient_rect: TextureRect = %IngredientRect
@onready var ingredient_label: Label = %IngredientLabel
@onready var price_label: Label = %PriceLabel
@onready var quantity_label: Label = %QuantityLabel

var ingredient_name: String
var basket:Basket = Basket.load_basket()


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func set_item_data(ingredient: Dictionary):
	ingredient_name = ingredient["name"]  # Assign the name
	ingredient_label.text = ingredient_name
	price_label.text = str(int(ingredient["price"]))
	quantity_label.text = str(int(ingredient["quantity"]))
	
	# Set the image from the resource
	if ingredient.has("image") and ingredient["image"] is Texture2D:
		ingredient_rect.texture = ingredient["image"]
	else:
		ingredient_rect.texture = null  # Fallback in case of missing texture

func _on_add_button_pressed() -> void:
	print(basket, "workiung")
	var ingredient_data = basket.items.get(ingredient_name)
	print(ingredient_data, "working")
	if ingredient_data:
		basket.add_item(Ingredient.new_from_dict(ingredient_data), 1)  # Convert dict to Ingredient
		print(Ingredient.new_from_dict(ingredient_data), "working11111")
		basket.save_basket()  # Save changes
		update_display()
		print("Added item:", ingredient_name)
	else:
		print("Error: Ingredient not found in basket")
	

# Subtract quantity, remove if zero
func _on_minus_button_pressed() -> void:
	basket.subtract_item(ingredient_name, 1)
	basket.save_basket()
	update_display()

# Remove from basket
func _on_remove_button_pressed() -> void:
	basket.remove_item(ingredient_name)
	basket.save_basket()
	queue_free()  # Remove from UI

	#
# Update the UI
func update_display():
	var item = basket.items.get(ingredient_name)
	if item:
		quantity_label.text = str(int(item["quantity"]))
	else:
		queue_free()  # Remove if item is no longer in the basket
