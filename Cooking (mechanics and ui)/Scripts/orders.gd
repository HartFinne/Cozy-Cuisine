extends HBoxContainer

var order_container_scene = preload("res://Cooking (mechanics and ui)/Scenes/order_container.tscn")
var player_data: PlayerData = PlayerData.load_data()
@onready var order_vbox: VBoxContainer = %OrderVbox
@onready var orders_button: Button = %OrdersButton
@onready var dish_button: Button = $"../DishButton"


@onready var order_back_button: Button = $OrderBackButton

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	populate_order_container()
	pass
	
func populate_order_container():
	for child in order_vbox.get_children():
		child.queue_free()
		
	var order = player_data.order
	
	for player_name in order.keys():
		print(player_name, "player")
		
		var dish_list = order[player_name]
		print(dish_list)
		
		var order_instance = order_container_scene.instantiate()
		
		if order_instance.has_method("set_order_data"):
			order_instance.set_order_data(dish_list, player_name)
			
		order_vbox.add_child(order_instance)
			
		


func _on_orders_button_pressed() -> void:
	print("working")
	self.visible = true
	orders_button.visible = false
	dish_button.visible = false
	pass # Replace with function body.


func _on_order_back_button_pressed() -> void:
	self.visible = false
	orders_button.visible = true
	dish_button.visible = true
	pass # Replace with function body.
	

# ------------------------------------------------------------------------------------------------------


func _on_dish_button_pressed() -> void:
	var dishes_node = get_node("/root/CookingScene/Dishes")
	var order_node = get_node("/root/CookingScene/Orders")
	print(dishes_node)
	print(order_node)
	print("working")
	pass # Replace with function body.
