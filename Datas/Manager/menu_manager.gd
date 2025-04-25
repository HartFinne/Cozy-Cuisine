extends Node


var menu_items: Dictionary = {}  # Key: Name, Value: MenuItem resource
var recipes: Array[MenuItem] = []
var ingredients: Array[Ingredient] = []


func _ready():
	load_recipes()
	load_ingredients()
	
	

func load_recipes():
	var recipes_path = [
		"res://Datas/Resources/MenuItems/BurgerSteak.tres",
		"res://Datas/Resources/MenuItems/MilkShake.tres",
		"res://Datas/Resources/MenuItems/PepperoniPizza.tres",
		"res://Datas/Resources/MenuItems/Fries.tres",
		"res://Datas/Resources/MenuItems/IceCream.tres"
	]
	
	for path in recipes_path:
		var recipe = load(path) as MenuItem
		if recipe:
			recipes.append(recipe)
			print("Loaded Recipe - Ingredients:", recipe.ingredients, "Result:", recipe.name)
			
			
func load_ingredients():
	var ingredients_path = [
		"res://Datas/Resources/Ingredients/Burger_Steak/Meat.tres",
		"res://Datas/Resources/Ingredients/Burger_Steak/MixedVeg.tres",
		"res://Datas/Resources/Ingredients/Burger_Steak/Mushroom.tres",
		"res://Datas/Resources/Ingredients/Burger_Steak/SteakSauce.tres",
		"res://Datas/Resources/Ingredients/French_Fries/Oil.tres",
		"res://Datas/Resources/Ingredients/French_Fries/Potatoes.tres",
		"res://Datas/Resources/Ingredients/French_Fries/Salt.tres",
		"res://Datas/Resources/Ingredients/Ice_Cream/Choco.tres",
		"res://Datas/Resources/Ingredients/Ice_Cream/Cone.tres",
		"res://Datas/Resources/Ingredients/Ice_Cream/Strawberry.tres",
		"res://Datas/Resources/Ingredients/Milkshake/Ice.tres",
		"res://Datas/Resources/Ingredients/Milkshake/Milk.tres",
		"res://Datas/Resources/Ingredients/Milkshake/Sugar.tres",
		"res://Datas/Resources/Ingredients/Milkshake/Vanilla.tres",
		"res://Datas/Resources/Ingredients/Pizza/Cheese.tres",
		"res://Datas/Resources/Ingredients/Pizza/Dough.tres",
		"res://Datas/Resources/Ingredients/Pizza/Pepperoni.tres",
		"res://Datas/Resources/Ingredients/Pizza/PizzaSauce.tres",
	]
	
	for path in ingredients_path:
		var ingredient = load(path) as Ingredient
		if ingredient:
			ingredients.append(ingredient)
			print("Loaded Recipe - Ingredients:", ingredient.name, "Result:", ingredient.label)
			
