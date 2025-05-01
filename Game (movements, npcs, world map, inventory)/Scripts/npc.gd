extends CharacterBody2D

var player_data: PlayerData = PlayerData.load_data()

@onready var start_conversation: NinePatchRect = $StartConversation
@onready var thought_bubble_scene: Control = $ThoughtBubbleScene


@onready var dialogue: Control = $Dialogue
@export var customer: Customer

var player_in_area: bool = false
var x_button: TouchScreenButton  # Declare variable
var take_button: Button
var serve_button: Button
var path_follow: PathFollow2D

var customer_data = GameData.load_customers()

func _ready() -> void:
	# ✅ Ensure UI is fully loaded before accessing XButton
	print(customer)
	var ui = get_tree().get_root().find_child("UI", true, false)

	x_button = ui.find_child("XButton", true, false)
	take_button = ui.find_child("TakeButton", true, false)
	serve_button = ui.find_child("ServeButton", true, false)
	

	


func _process(delta: float) -> void:
	if player_in_area and Input.is_action_just_pressed("accept"):
		dialogue.visible = true
		start_conversation.visible = false
		x_button.visible = false
		show_customer_order()
		
		if take_button and not take_button.is_connected("pressed", Callable(self, "_on_take_button_pressed")):
			take_button.connect("pressed", Callable(self, "_on_take_button_pressed"))

		if serve_button and not serve_button.is_connected("pressed", Callable(self, "serve_dish_to_customer")):
			serve_button.connect("pressed", Callable(self, "serve_dish_to_customer"))
		



func show_customer_order():
	# Hide the take button after taking the order
	var dishes = player_data.dishes
	hide_taken_button_if_order_taken()
	if customer and customer.order:
		var name_text = customer.name + "'s Order:\n"
		var order_text: String

		for item_name in customer.order.keys():
			var found_recipe = null
			for recipe in MenuManager.recipes:
				if recipe.name == item_name:
					found_recipe = recipe
				
			if found_recipe:
				if dishes.has(item_name):
					order_text += str(int(dishes[item_name].get("quantity", 0))) + " / " + str(customer.order[item_name]) + " x " + found_recipe.label + "\n"
				else:
					order_text += "0 /" + str(customer.order[item_name]) + " x " + found_recipe.label + "\n"
				
		print("Debug - Order Text:", order_text)
		dialogue.set_dialog_text(name_text, order_text)
	else:
		print("Order data is missing or empty")


func _on_take_button_pressed():
	if customer and customer.order:
		# Assuming customer.order is a dictionary like: {"PeperoniPizza": 2}
		print("working", customer.order)

		# Duplicate the customer order to avoid shared reference issues
		var customer_order_copy = customer.order.duplicate(true)  # This creates a unique copy of the order

		# If the player already has an order for this customer, we don't overwrite it
		if not player_data.order.has(customer.name):
			# Create the order with customer.name as the key if it doesn't already exist
			player_data.order[customer.name] = customer_order_copy
		else:
			# You can add more logic here if you want to modify an existing order (optional)
			player_data.order[customer.name] = customer_order_copy

		print("Customer Name:", customer.name)
		print("Player Order:", player_data.order)

		# Save the player data
		player_data.save()
		take_button.visible = false
		dialogue.visible = false

		show_order_bubbles(true)

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
		
func show_order_bubbles(served: bool):
	# need to show the icon of the foods of the orders and how many of it like
	# example: cheese(icon) 0/1
	if served:
		thought_bubble_scene.visible = false
		
	thought_bubble_scene.visible = true
		
		
func reach_counter(path_follow_node: PathFollow2D):
	path_follow = path_follow_node
	print("Customer has stopped at counter")

# Function to serve the dish to the customer
func serve_dish_to_customer():
	if not customer or not customer.order:
		print("Customer has no order to serve")
		return  

	var total_price = 0.0  # Initialize total price
	var total_expense := 0.0

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
		print(dish, "asdkjfhasdjksafhsakljfdhfjfhalkjfdhfsljkahfljsahfdafsakjfh")
		
		if dish.has("ingredients"):
			for ingredient_name in dish["ingredients"].keys():
				var quantity = dish["ingredients"][ingredient_name] * required_quantity  # <-- Multiply by quantity ordered
				var ingredient_path = "res://Datas/Resources/Ingredients/" + ingredient_name + ".tres"
				var ingredient_res = load(ingredient_path)
				if ingredient_res and ingredient_res is Ingredient:
					total_expense += ingredient_res.price * quantity
					print("Used ", quantity, "x ", ingredient_name, " (", ingredient_res.price, " each)")
				else:
					print("⚠️ Could not load ingredient: ", ingredient_name)
			
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
	player_data.expenses += total_expense
	player_data.order.erase(customer.name)
	player_data.save()

	if total_price <= 0:
		print("No payment needed. Customer has no order.")
		return  

	print(customer.name, " paid ", total_price, " coins.")
	dialogue.set_dialog_text(customer.name + "'s Payment", "Thank you! Here is " + str(total_price) + " coins.")

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
			test_scene_node.customer_paid(total_price)
			test_scene_node.get_node("UI/CanvasLayer/Inventory").populate_inventory_container()
			
		else:
			print("Error: TestScene node not found or missing method!")


func _on_area_2d_body_entered(body: Node2D) -> void:
	print("Body entered:", body.name)  # Debugging: Print
	if body.is_in_group("player"): # Ensure it's the player
		player_in_area = true
		print("Player entered NPC area")
		start_conversation.visible = true

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_in_area = false
		print("Player left NPC area")
		dialogue.visible = false
		start_conversation.visible = false
		x_button.visible = true
		take_button.visible = false
		serve_button.visible = false
