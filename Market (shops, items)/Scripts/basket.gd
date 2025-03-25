extends TabBar

@onready var grid_container_2: GridContainer = %GridContainer2
@export var basket_scene: PackedScene

var basket_data

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	update_basket_display()
	BasketManager.basket_updated.connect(update_basket_display)  # Listen for changes


func update_basket_display():
	for child in grid_container_2.get_children():
		child.queue_free()
		
	basket_data = BasketManager.basket_data
	
	for item_name in basket_data.keys():
		var ingredient = basket_data[item_name]
		print(ingredient)
		var basket_instance = basket_scene.instantiate()
		
		grid_container_2.add_child(basket_instance)
		basket_instance.set_item_data(ingredient)
	
