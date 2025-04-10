extends NinePatchRect


func set_dish_data(dish):
	print(dish, "niggas")
	%DishName.text = dish.label
	%DishImage.texture = dish.image
	
	var ingredient_text := ""
	for ingredient in dish.ingredients.keys():
		var quantity = dish.ingredients[ingredient]
		ingredient_text += str(int(quantity)) + " x " + ingredient + "\n"
	
	%IngredientName.text = ingredient_text.strip_edges()
