extends Control

var current_index: int = 0
var shop_list: Array = []

signal shop_selected(current_index)

@onready var shop_name_label: Label = %ShopNameLabel
@onready var shop_rect: TextureRect = %ShopRect

func _ready() -> void:
	load_shops_from_resources()
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

func load_shops_from_resources():
	var shop_files = [
		"res://Datas/Resources/Markets/shop_1.tres",
		"res://Datas/Resources/Markets/shop_2.tres",
		"res://Datas/Resources/Markets/shop_3.tres"
	]

	shop_list.clear()
	print(shop_files)
	
	for shop_file in shop_files:
		var shop_resource = load(shop_file) as Resource
		if shop_resource:
			shop_list.append(shop_resource)
		else:
			print("Error: Unable to load shop resource:", shop_file)

	if shop_list.is_empty():
		print("Error: No shop data found in resources")
	else:
		print("Loaded", shop_list.size(), "shops successfully.")

func update_shop_display():
	if shop_list.size() > 0:
		var market: Market = shop_list[current_index]
		shop_name_label.text = market.shop_name

		# Use shop_image directly from Market resource
		if market.shop_image:
			shop_rect.texture = market.shop_image
		else:
			shop_rect.texture = null
	else:
		shop_name_label.text = "No Shops Available"
		shop_rect.texture = null

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

func _on_setting_button_pressed() -> void:
	print("Next Update: Setting Button")

func _on_back_button_pressed() -> void:
	print("Working")
