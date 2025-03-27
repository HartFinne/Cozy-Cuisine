extends PopupPanel

@export var ingredient: Ingredient  # Link to an Ingredient resource
@onready var label: Label = $VBoxContainer/Label
@onready var v_box_container: VBoxContainer = $VBoxContainer

var ingredient_list: Array = [] 
var selected_ingredient_slot = null  # Store the clicked ingredient slot

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	load_ingredients_from_resources()
	update_popup_ui()


func show_popup(ingredient_slot):
	print(ingredient_slot)
	selected_ingredient_slot = ingredient_slot  # Store the clicked slot
	visible = true  # Show popup


func load_ingredients_from_resources():
	var ingredient_files = [
		"res://Datas/Resources/Ingredients/Cheese.tres",
		"res://Datas/Resources/Ingredients/Choco.tres",
		"res://Datas/Resources/Ingredients/Cone.tres"
	]
	
	ingredient_list.clear()
	print(ingredient_files)
	
	for ingredient_file in ingredient_files:
		var ingredient_resource = load(ingredient_file) as Ingredient
		if ingredient_resource:
			ingredient_list.append(ingredient_resource)
		else:
			print("Error: Unable to load ingredient resource:", ingredient_file)
			
	if ingredient_list.is_empty():
		print("Error: No ingredient data found in resources")
	else:
		print("Loaded", ingredient_list.size(), "ingredient successfully.")
		
func update_popup_ui():
	# Add new ingredient names
	for ingredient in ingredient_list:
		var ingredient_label = Label.new()
		var close_button = Button.new()
		ingredient_label.text = "- " + ingredient.name
		v_box_container.add_child(ingredient_label)
	
	print("Popup UI updated with", ingredient_list.size(), "ingredients")
	
	
