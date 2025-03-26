extends TabBar

@onready var grid_container: GridContainer = %GridContainer
@onready var scroll_container: ScrollContainer = %ScrollContainer
@export var ingredient_scene: PackedScene

var ingredients: Array = []
var shop_list: Array = []

func _ready() -> void:
	pass

func _on_shop_selected(shop_index: int):
	scroll_container = %ScrollContainer
	grid_container = %GridContainer
	
	# Remove existing ingredients
	for child in grid_container.get_children():
		child.queue_free()
	
	# Fetch shop_list from shops.gd
	var shops_node = get_parent().get_parent().get_node("Shops")  # Adjust this path as needed
	print(shops_node)
	if shops_node:
		shop_list = shops_node.shop_list  # Get updated shop list
	
	if shop_index >= 0 and shop_index < shop_list.size():
		ingredients = shop_list[shop_index]["ingredients"]
		populate_ingredients()
		
func populate_ingredients():
	for ingredient in ingredients:
		var ingredient_instance = ingredient_scene.instantiate()
		grid_container.add_child(ingredient_instance)
		ingredient_instance.set_ingredient_display(ingredient["name"], ingredient["price"], ingredient["image"])
		
