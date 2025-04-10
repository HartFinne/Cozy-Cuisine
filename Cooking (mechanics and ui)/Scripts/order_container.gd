extends NinePatchRect



func set_order_data(dish_list: Dictionary, player_name: String):
	%Name.text = player_name
	
	var order_text := ""
	for dish_name in dish_list.keys():
		var quantity = dish_list[dish_name]
		order_text += str(int(quantity)) + " x " + dish_name + "\n"
	
	%Order.text = order_text.strip_edges()
	
