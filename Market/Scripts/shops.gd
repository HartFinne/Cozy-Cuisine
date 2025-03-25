extends PanelContainer


var current_index: int = 0
var shop_list: Array = [
	{ "name": "Shop 1", "ingredients": ["Apple", "Banana", "Carrot"] },
	{ "name": "Shop 2", "ingredients": ["Tomato", "Onion", "Potato"] }
]
signal shop_selected(current_index)

@onready var shop_name_label: Label = %ShopNameLabel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var tab_container = get_parent().get_node("TabContainer")  
	if not (tab_container is TabContainer):
		return  

	var available_tab = tab_container.get_node("Available")  
	if not available_tab:
		return  

	print("Signal connected")
	# Check if the signal is already connected to avoid duplicates
	if not is_connected("shop_selected", Callable(available_tab, "_on_shop_selected")):
		connect("shop_selected", Callable(available_tab, "_on_shop_selected"))

	update_shop_display()
	select_shop(current_index)  # Move this after the connection ✅


func select_shop(index):
	print("Emitting signal: shop_selected with index", index)
	emit_signal("shop_selected", index)

func _on_left_button_pressed() -> void:
	if current_index > 0:
		current_index -= 1
	else:
		current_index = shop_list.size() - 1
	select_shop(current_index)  # Call select_shop to emit the signal ✅
	update_shop_display()
	
	

func _on_right_button_pressed() -> void:
	if current_index < shop_list.size() - 1:
		current_index += 1
	else:
		current_index = 0
	update_shop_display()
	select_shop(current_index)  # Call select_shop to emit the signal ✅
	
func update_shop_display():
	shop_name_label.text = shop_list[current_index]["name"]  # Fixed syntax
