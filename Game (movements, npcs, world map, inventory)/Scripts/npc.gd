extends CharacterBody2D

var player_data: PlayerData = PlayerData.load_data()

@onready var dialogue: Control = $Dialogue
@export var customer: Customer

var player_in_area: bool = false
var x_button: TouchScreenButton  # Declare variable
var take_button: Button
var serve_button: Button
var path_follow: PathFollow2D

var customer_data = GameData.load_customers()


func _ready():
	# ✅ Ensure UI is fully loaded before accessing XButton
	print(customer)
	var ui = get_tree().get_root().find_child("UI", true, false)

	x_button = ui.find_child("XButton", true, false)
	take_button = ui.find_child("TakeButton", true, false)
	serve_button = ui.find_child("ServeButton", true, false)


func _process(delta: float) -> void:
	if player_in_area and Input.is_action_just_pressed("accept"):
		dialogue.visible = true
		%StartConversation.visible = false
		x_button.visible = false
		show_customer_order()
		
		if take_button:
			take_button.connect("pressed", Callable(self, "_on_take_button_pressed"))
			
		if serve_button:
			serve_button.connect("pressed", Callable(self, "serve_dish_to_customer"))



func show_customer_order():
	# Hide the take button after taking the order
	hide_taken_button_if_order_taken()
	if customer and customer.order:
		var name_text = customer.name + "'s Order:\n"
		var order_text: String

		for item_name in customer.order.keys():
			var menu_item = MenuManagers.menu_items.get(item_name)  # ✅ Fetch from global menu

			if menu_item:
				order_text += str(customer.order[item_name]) + " " + menu_item.label
			else:
				order_text += item_name

		print("Debug - Order Text:", order_text)
		dialogue.set_dialog_text(name_text, order_text)
	else:
		print("⚠️ Order data is missing or empty!")


func _on_take_button_pressed():
	if customer and customer.order:
		# Assuming customer.order is a dictionary like: {"PeperoniPizza": 2}
		print("working", customer.order)
		
		# If the player already has an order for this customer, we don't overwrite it
		if not player_data.order.has(customer.name):
			# Create the order with customer.name as the key if it doesn't already exist
			player_data.order[customer.name] = customer.order
		else:
			# Otherwise, you can modify the existing order (optional)
			# For example, you can add more items to the order, etc.
			player_data.order[customer.name] = customer.order

		print("Customer Name:", customer.name)
		print("Player Order:", player_data.order)
		
		# Save the player data
		player_data.save()
		take_button.visible = false
		dialogue.visible = false
		
	else:
		print("NO order to take")


func hide_taken_button_if_order_taken():
	if player_data.order.has(customer.name):
		print("hide button")
		take_button.visible = false
		serve_button.visible = true
	else:
		take_button.visible = true
		serve_button.visible = false
		
		
func reach_counter(path_follow_node: PathFollow2D):
	path_follow = path_follow_node
	print("Customer has stopped at counter")

# Function to serve the dish to the customer
func serve_dish_to_customer():
	if not customer or not customer.order:
		print("Customer has no order to serve")
		return  

	var total_price = 0.0  # Initialize total price

	# Loop through the customer's order and check if player has enough of each dish
	for dish_name in customer.order.keys():
		var required_quantity = customer.order[dish_name]

		# Check if the dish exists in player_data.dishes
		if not player_data.dishes.has(dish_name):
			print("Dish not found:", dish_name)
			dialogue.set_dialog_text(customer.name + "'s Order", "Sorry, we don't have that dish.")
			return  

		var dish = player_data.dishes[dish_name]
		var player_quantity = dish.get("quantity", 0)

		print(player_quantity, "workins")  # Debugging print
		print(required_quantity, "kimh")  # Debugging print

		if player_quantity < required_quantity:
			dialogue.set_dialog_text(customer.name + "'s Order", "Sorry, I don't have enough " + dish_name)
			print("Not enough ", dish_name, " to serve ", customer.name)
			return  

		# Calculate total price
		total_price += dish.get("price", 0.0) * required_quantity  

		# Player has enough of the dish, serve it
		dish["quantity"] -= required_quantity  

		# Remove the dish from player_data.dishes if quantity is 0
		if dish["quantity"] <= 0:
			player_data.dishes.erase(dish_name)  

		# Notify the player
		print("Serving ", required_quantity, " of ", dish_name, " to ", customer.name)

	# Remove the order after serving all dishes
	player_data.order.erase(customer.name)
	player_data.save()

	# Inform the customer
	dialogue.set_dialog_text(customer.name + "'s Order Served", "Here is your order!")

	# Call customer_pays with the calculated total price
	customer_pays(total_price)

	# Order is complete
	print("Order completed for ", customer.name)



func customer_pays(total_price: float):
	if total_price <= 0:
		print("No payment needed. Customer has no order.")
		return  

	# Update financials
	player_data.revenue += total_price  
	player_data.profit = player_data.revenue - player_data.expenses  
	player_data.total_profit += total_price  
	player_data.budget += total_price  

	print(customer.name, " paid ", total_price, " coins.")
	dialogue.set_dialog_text(customer.name + "'s Payment", "Thank you! Here is " + str(total_price) + " coins.")

	# Save updated data
	player_data.save()

	# Hide UI elements after payment
	dialogue.visible = false
	take_button.visible = false
	serve_button.visible = false
	
	if path_follow:
		print("Path follow is valid!")
	else:
		print(path_follow)
		print("Path follow is not valid.")
	
	if path_follow:
		var test_scene_node = get_tree().get_root().get_node("TestingScene")  # Ensure this matches your scene name
		print(test_scene_node, "parent")
		if test_scene_node and test_scene_node.has_method("resume_customer_movement"):
			test_scene_node.resume_customer_movement(path_follow)
		else:
			print("Error: TestScene node not found or missing method!")




func _on_area_2d_body_entered(body: Node2D) -> void:
	print("Body entered:", body.name)  # Debugging: Print
	if body.is_in_group("player"): # Ensure it's the player
		player_in_area = true
		print("Player entered NPC area")
		%StartConversation.visible = true
		
func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_in_area = false
		print("Player left NPC area")
		dialogue.visible = false
		%StartConversation.visible = false
		x_button.visible = true
		take_button.visible = false
		serve_button.visible = false
