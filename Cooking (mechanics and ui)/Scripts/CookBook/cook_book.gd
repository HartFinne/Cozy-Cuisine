extends PanelContainer
@onready var margin_container: MarginContainer = $VBoxContainer/MarginContainer/HBoxContainer/MarginContainer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	margin_container.visible = false
	pass # Replace with function body.

func show_meal_details(meal):
	margin_container.visible = true
	print("working", meal.image)
	var meal_image = %MealImage
	var meal_name = %MealName
	var item_list = %ItemList
	var description = %DescriptionOutput
	var price = %PriceOutput

	
	meal_image.texture = meal.image
	meal_name.text = meal.label
	description.text = meal.description
	price.text = str(int(meal.price))
	
	item_list.clear()

	for ingredient in meal.ingredients.keys():
		var amount = meal.ingredients[ingredient]
		item_list.add_item("%s: %d" % [ingredient, amount])
		
		
func show_ingredient_details(ingredient):
	margin_container.visible = true
	print("working", ingredient.label)
	var meal_image = %MealImage
	var meal_name = %MealName
	var item_list = %ItemList
	var description = %DescriptionOutput
	var price = %PriceOutput
	var ingredient_name = %Ingredient
	
	meal_image.texture = ingredient.image
	meal_name.text = ingredient.label
	description.text = ingredient.description
	price.text = str(int(ingredient.price))
	item_list.hide()
	ingredient_name.visible = false
	
		


func _on_button_pressed() -> void:
	SceneManager.return_to_game()
