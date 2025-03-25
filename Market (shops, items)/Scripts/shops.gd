extends PanelContainer

var current_index: int = 0
var shop_list: Array = []

signal shop_selected(current_index)

@onready var shop_name_label: Label = %ShopNameLabel
@onready var shop_rect: TextureRect = %ShopRect

func _ready() -> void:
	load_shops()
	var tab_container = get_parent().get_node("TabContainer")  
	if not (tab_container is TabContainer):
		return  

	var available_tab = tab_container.get_node("Available")  
	if not available_tab:
		return  

	print("Signal connected")
	if not is_connected("shop_selected", Callable(available_tab, "_on_shop_selected")):
		connect("shop_selected", Callable(available_tab, "_on_shop_selected"))

	update_shop_display()
	select_shop(current_index)

func load_shops():
	var data = IngredientLoader.ingredients_data  # Access global data
	
	if data.is_empty():
		print("Error: No data loaded from ingredient_loader")
		return

	var shops_data = data.get("Shops", {})
	var ingredients_data = data.get("Ingredients", {})

	var shop_dict := {}

	for key in ingredients_data.keys():
		var ingredient = ingredients_data[key]
		var shop_name = ingredient["Shop"]
		var price = ingredient["Price"]
		var ingredient_image = ingredient.get("Image", "")  # Get ingredient image

		if not shop_dict.has(shop_name):
			shop_dict[shop_name] = {
				"name": shop_name,
				"image": shops_data.get(shop_name, {}).get("Image", ""),  # Fetch shop image
				"ingredients": []
			}

		# Store ingredient name, price, and image under its shop
		shop_dict[shop_name]["ingredients"].append({
			"name": key,
			"price": price,
			"image": ingredient_image  # Store ingredient image
		})

	# Convert dictionary to array format
	shop_list = shop_dict.values()

	print("Loaded shops:", shop_list)

func select_shop(index):
	print("Emitting signal: shop_selected with index", index)
	emit_signal("shop_selected", index)

func _on_left_button_pressed() -> void:
	if current_index > 0:
		current_index -= 1
	else:
		current_index = shop_list.size() - 1
	select_shop(current_index)
	update_shop_display()

func _on_right_button_pressed() -> void:
	if current_index < shop_list.size() - 1:
		current_index += 1
	else:
		current_index = 0
	update_shop_display()
	select_shop(current_index)

func update_shop_display():
	if shop_list.size() > 0:
		var shop_data = shop_list[current_index]
		shop_name_label.text = shop_data["name"]

		# Load and set shop image
		var image_path = shop_data["image"]
		if image_path:
			var texture = load(image_path)
			if texture:
				shop_rect.texture = texture
			else:
				print("Error loading shop image:", image_path)
		else:
			shop_rect.texture = null
	else:
		shop_name_label.text = "No Shops Available"
		shop_rect.texture = null
