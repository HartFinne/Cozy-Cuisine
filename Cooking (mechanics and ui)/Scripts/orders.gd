extends HBoxContainer

signal customer_left(customer_name: String)

var order_container_scene = preload("res://Cooking (mechanics and ui)/Scenes/order_container.tscn")
var player_data: PlayerData = PlayerData.load_data()
var dishes = player_data.dishes

@onready var order_vbox: VBoxContainer = %OrderVbox
@onready var orders_button: Button = %OrdersButton
@onready var dish_button: Button = $"../DishButton"

var previous_orders = {}  # Store previous orders to detect when customers leave
var check_interval: float = 0.5  # Check every half second
var time_since_last_check: float = 0.0

@onready var order_back_button: Button = $OrderBackButton

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	populate_order_container()
	get_parent().connect("dish_collected", Callable(self, "populate_order_container"))
	previous_orders = player_data.order.duplicate(true)  # Store initial orders

func _process(delta: float) -> void:
	# Update timer
	time_since_last_check += delta
	
	# Check for changes in orders periodically
	if time_since_last_check >= check_interval:
		check_for_left_customers()
		time_since_last_check = 0  # Reset timer
	
func check_for_left_customers() -> void:
	var current_orders = player_data.order
	
	# Check for customers who have left
	for customer_name in previous_orders.keys():
		if not current_orders.has(customer_name):
			# Customer has left, emit signal with clean name
			var name_parts = customer_name.split("_")
			var clean_name = name_parts[0]  # Get base name without identifier
			emit_signal("customer_left", clean_name)
			# Update the orders display
			populate_order_container()
	
	# Update previous orders
	previous_orders = current_orders.duplicate(true)
	
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
			order_instance.set_order_data(dish_list, player_name, dishes)
			
		order_vbox.add_child(order_instance)

func _on_orders_button_pressed() -> void:
	print("working")
	populate_order_container()
	self.visible = true
	orders_button.visible = false
	dish_button.visible = false
	
	pass # Replace with function body.


func _on_order_back_button_pressed() -> void:
	self.visible = false
	orders_button.visible = true
	dish_button.visible = true
	pass # Replace with function body.
	
