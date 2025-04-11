extends NinePatchRect



func set_order_data(dish_list: Dictionary, player_name: String, dishes: Dictionary):
	print("workingsss", "dshajfhdskfjshfkljsadhfsadjhdsakjlfhdskjfsdjfhsdkjfhasdkljfhsadkfhsdkjlfhjskdfhksadhfkl")
	%Name.text = player_name
	
	var order_text := ""
	for dish_name in dish_list.keys():
		print("Checking dish:", dish_name)  # Debugging line
		var quantity = dish_list[dish_name]
		
		if dishes.has(dish_name):
			order_text += str(dishes[dish_name].get("quantity", 0)) + " / " + str(quantity) + " x " + dishes[dish_name].get("label", dish_name) + "\n"
		else:
			order_text += "0 / " + str(quantity) + " x " + dish_name + "\n"


	%Order.text = order_text.strip_edges()
	
