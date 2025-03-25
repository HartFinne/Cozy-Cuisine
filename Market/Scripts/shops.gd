extends PanelContainer


var current_index: int = 0
var shop_list: Array = ["Shop A", "Shop B", "Shop C"]

@onready var shop_name_label: Label = %ShopNameLabel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	update_shop_display()

func _on_left_button_pressed() -> void:
	if current_index > 0:
		current_index -= 1
	else:
		current_index = shop_list.size() - 1
	update_shop_display()
	

func _on_right_button_pressed() -> void:
	if current_index < shop_list.size() - 1:
		current_index += 1
	else:
		current_index = 0
	update_shop_display()
	
func update_shop_display():
	shop_name_label.text = shop_list[current_index]
