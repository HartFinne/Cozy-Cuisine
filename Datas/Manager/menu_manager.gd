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
		"res://Datas/Resources/MenuItems/PepperoniPizza.tres"
	]
	
	for path in recipes_path:
		var recipe = load(path) as MenuItem
		if recipe:
			recipes.append(recipe)
			print("Loaded Recipe - Ingredients:", recipe.ingredients, "Result:", recipe.name)
			
			
func load_ingredients():
	var ingredients_path = [
		"res://Datas/Resources/Ingredients/Cheese.tres",
		"res://Datas/Resources/Ingredients/Choco.tres",
		"res://Datas/Resources/Ingredients/Cone.tres",
		"res://Datas/Resources/Ingredients/Dough.tres",
		"res://Datas/Resources/Ingredients/Ice.tres",
		"res://Datas/Resources/Ingredients/Meat.tres",
		"res://Datas/Resources/Ingredients/Milk.tres",
		"res://Datas/Resources/Ingredients/MixedVeg.tres",
		"res://Datas/Resources/Ingredients/Oil.tres",
		"res://Datas/Resources/Ingredients/Peperoni.tres",
		"res://Datas/Resources/Ingredients/PizzaSauce.tres",
		"res://Datas/Resources/Ingredients/Potatoes.tres",
		"res://Datas/Resources/Ingredients/Salt.tres",
		"res://Datas/Resources/Ingredients/SteakSauce.tres",
		"res://Datas/Resources/Ingredients/Strawberry.tres",
		"res://Datas/Resources/Ingredients/Sugar.tres",
		"res://Datas/Resources/Ingredients/Vanilla.tres",
	]
	
	for path in ingredients_path:
		var ingredient = load(path) as Ingredient
		if ingredient:
			ingredients.append(ingredient)
			print("Loaded Recipe - Ingredients:", ingredient.name, "Result:", ingredient.label)
			
