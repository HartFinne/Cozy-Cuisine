extends TabBar

@onready var grid_container: GridContainer = %GridContainer
@onready var scroll_container: ScrollContainer = %ScrollContainer
@export var ingredient_scene: PackedScene

var ingredients: Array = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _on_shop_selected(shop_index: int):
	scroll_container = %ScrollContainer
	grid_container = %GridContainer
	for child in grid_container.get_children():
		child.queue_free()
	
	var shop_list = [
		{ "name": "Shop 1", "ingredients": ["Apple", "Banana", "Carrot", "Apple", "Banana", "Carrot", "Apple", "Banana", "Carrot"] },
		{ "name": "Shop 2", "ingredients": ["Tomato", "Onion", "Potato"] }
	]
	
	if shop_index >= 0 and shop_index < shop_list.size():
		ingredients = shop_list[shop_index]["ingredients"]
		populate_ingredients()
		
		

func populate_ingredients():
	for ingredient_name in ingredients:
		var ingredient_instance = ingredient_scene.instantiate()
		grid_container.add_child(ingredient_instance)
		ingredient_instance.set_ingredient_name(ingredient_name)
		
