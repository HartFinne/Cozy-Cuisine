extends PanelContainer

@onready var ingredient_rect: TextureRect = %IngredientRect
@onready var ingredient_label: Label = %IngredientLabel
@onready var price_label: Label = %PriceLabel
@onready var quantity_label: Label = %QuantityLabel

var ingredient_name: String


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func set_item_data(ingredient: Dictionary):
	ingredient_name = ingredient["name"]  # Assign the name
	ingredient_label.text = ingredient_name
	price_label.text = str(int(ingredient["price"]))
	quantity_label.text = str(int(ingredient["quantity"]))
	
	# Load and set the item image
	var texture = load(ingredient["image"])
	if texture:
		ingredient_rect.texture = texture
		

func _on_add_button_pressed() -> void:
	print(ingredient_name)
	BasketManager.add_quantity(ingredient_name)
	update_display()
	print("add button working")
	

# Subtract quantity, remove if zero
func _on_minus_button_pressed() -> void:
	BasketManager.subtract_quantity(ingredient_name)
	update_display()

# Remove from basket
func _on_remove_texture_button_pressed() -> void:
	BasketManager.remove_from_basket(ingredient_name)
	queue_free()  # Remove from UI

	
# Update the UI
func update_display():
	var item = BasketManager.basket_data.get(ingredient_name)
	if item:
		quantity_label.text = str(int(item["quantity"]))
	else:
		queue_free()  # Remove if item is no longer in the basket
