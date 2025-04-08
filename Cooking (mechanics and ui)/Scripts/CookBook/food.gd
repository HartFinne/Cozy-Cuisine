extends VBoxContainer
@onready var meal: Label = %Meal
@onready var grid_container: GridContainer = %GridContainer
@onready var grid_container_2: GridContainer = %GridContainer2

var meal_container_scene = preload("res://Cooking (mechanics and ui)/Scenes/CookBook/meal_container.tscn")
var ingredient_container_scene = preload("res://Cooking (mechanics and ui)/Scenes/CookBook/ingredient_container.tscn")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	update_meal_ui()
	update_ingredient_ui()
	pass # Replace with function body.
	
func update_meal_ui():
	for meal in MenuManager.recipes:
		var meal_instance = meal_container_scene.instantiate()
		print(meal, "dklfsaklfdsahsahsjk")
		meal_instance.set_data_ui(meal)
		grid_container.add_child(meal_instance)
		
		# Connect Signal
		meal_instance.connect("meal_selected", Callable(self, "_on_meal_selected"))
		
func update_ingredient_ui():
	for ingredient in MenuManager.ingredients:
		var ingredient_instance = ingredient_container_scene.instantiate()
		ingredient_instance.set_data_ui(ingredient)
		grid_container_2.add_child(ingredient_instance)
		
		# Connect Signal
		ingredient_instance.connect("ingredient_selected", Callable(self, "_on_ingredient_selected"))
		
func _on_meal_selected(meal):
	var cook_book = get_parent().get_parent().get_parent().get_parent()
	print(cook_book.name, "cook")
	cook_book.show_meal_details(meal)
	
func _on_ingredient_selected(ingredient):
	var cook_book = get_parent().get_parent().get_parent().get_parent()
	if cook_book:
		cook_book.show_ingredient_details(ingredient)
