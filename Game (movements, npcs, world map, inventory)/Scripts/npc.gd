extends CharacterBody2D

var player_data: PlayerData = PlayerData.load_data()

@onready var start_conversation: NinePatchRect = $StartConversation
@onready var thought_bubble_scene: Control = $ThoughtBubbleScene
@onready var dialogue: Control = $Dialogue
@onready var patience_bar = $PatienceBar/TextureProgressBar


@export var customer: Customer

var player_in_area: bool = false
var x_button: TouchScreenButton  # Declare variable
var take_button: Button
var serve_button: Button
var path_follow: PathFollow2D

var customer_data = GameData.load_customers()

var patience_duration := 5  # seconds until patience reaches 0
var current_patience := 100.0
var has_paid = false
var total_price := 0.0

func _ready() -> void:
	current_patience = customer.patience_bar
	patience_bar.max_value = customer.patience_bar
	patience_bar.value = customer.patience_bar
	
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
		if x_button != null:
			x_button.visible = false
		# Hide thought bubble when showing dialogue
		thought_bubble_scene.visible = false
		show_customer_order()
		
		if take_button and not take_button.is_connected("pressed", Callable(self, "_on_take_button_pressed")):
			take_button.connect("pressed", Callable(self, "_on_take_button_pressed"))

		if serve_button and not serve_button.is_connected("pressed", Callable(self, "serve_dish_to_customer")):
			serve_button.connect("pressed", Callable(self, "serve_dish_to_customer"))
			
	
	if current_patience > 0:
		current_patience -= (customer.patience_bar / patience_duration) * delta
		patience_bar.value = current_patience

		if current_patience <= 0:
			current_patience = 0
			
			if player_data.order.has(customer.name):
				player_data.order.erase(customer.name)
				player_data.save()
			follow_path(0)

# Add helper function to get clean name
func get_clean_customer_name() -> String:
	if customer and customer.name:
		# Remove the unique identifier after the underscore
		var name_parts = customer.name.split("_")
		return name_parts[0]  # Return just the base name
	return "Customer"  # Fallback name

func show_customer_order():
	# Hide the take button after taking the order
	var dishes = player_data.dishes
	hide_taken_button_if_order_taken()
	if customer and customer.order:
		var clean_name = get_clean_customer_name()
		var name_text = clean_name + "'s Order:\n"
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
	if not player_in_area:
		print("Player not in interaction area")
		return
		
	if customer and customer.order:
		# Check if this customer's order has already been taken
		if player_data.order.has(customer.name):
			print("Order already taken for customer: ", customer.name)
			return
			
		current_patience = customer.patience_bar
		# Assuming customer.order is a dictionary like: {"PeperoniPizza": 2}
		print("working", customer.order)

		# Duplicate the customer order to avoid shared reference issues
		var customer_order_copy = customer.order.duplicate(true)  # This creates a unique copy of the order

		# Create the order with customer.name as the key
		player_data.order[customer.name] = customer_order_copy

		print("Customer Name:", customer.name)
		print("Player Order:", player_data.order)

		# Save the player data
		player_data.save()
		take_button.visible = false
		dialogue.visible = false
		# Show thought bubble after taking order
		show_order_bubbles(true)

	else:
		print("NO order to take")



func hide_taken_button_if_order_taken():
	if player_data.order.has(customer.name):
		print("hide button")
		if take_button != null:
			take_button.visible = false
		if serve_button != null:
			serve_button.visible = true
	else:
		if take_button != null:
			take_button.visible = true
		if serve_button != null:
			serve_button.visible = false
		
func show_order_bubbles(served: bool):
	# need to show the icon of the foods of the orders and how many of it like
	# example: cheese(icon) 0/1
	if served:
		# Show the bubble after the order was taken
		thought_bubble_scene.visible = true
	else:
		# Optionally hide it if not taken yet or served already
		thought_bubble_scene.visible = false

	if customer and customer.order:
		var dishes = player_data.dishes
		var order_data = []

		for item_name in customer.order.keys():
			var found_recipe = null
			for recipe in MenuManager.recipes:
				if recipe.name == item_name:
					found_recipe = recipe
					break

			if found_recipe:
				var player_qty = int(dishes[item_name].get("quantity", 0)) if dishes.has(item_name) else 0
				var needed_qty = customer.order[item_name]

				order_data.append({
					"label": found_recipe.label,
					"image": found_recipe.image,
					"have": player_qty,
					"need": needed_qty
				})

		# Populate UI
		thought_bubble_scene.populate_panel_container(order_data)
		
		
func reach_counter(path_follow_node: PathFollow2D):
	path_follow = path_follow_node
	print("Customer has stopped at counter")

# Function to serve the dish to the customer
func serve_dish_to_customer():
	if not customer or not customer.order:
		print("Customer has no order to serve")
		return  

	var total_expense := 0.0
	var total_price := 0.0

	# Loop through the customer's order and check if player has enough of each dish
	for dish_name in customer.order.keys():
		var required_quantity = customer.order[dish_name]

		# Check if the dish exists in player_data.dishes
		if not player_data.dishes.has(dish_name):
			print("Dish not found:", dish_name)
			dialogue.set_dialog_text(get_clean_customer_name() + "'s Order", "Sorry, we don't have that dish.")
			return  

		var dish = player_data.dishes[dish_name]
		var player_quantity = dish.get("quantity", 0)

		if player_quantity < required_quantity:
			dialogue.set_dialog_text(get_clean_customer_name() + "'s Order", "Sorry, I don't have enough " + dish_name)
			print("Not enough ", dish_name, " to serve ", get_clean_customer_name())
			return  

		# Calculate ingredient costs
		if dish.has("ingredients"):
			for ingredient_name in dish["ingredients"].keys():
				var quantity = dish["ingredients"][ingredient_name] * required_quantity
				var ingredient_path = "res://Datas/Resources/Ingredients/" + ingredient_name + ".tres"
				var ingredient_res = load(ingredient_path)
				if ingredient_res and ingredient_res is Ingredient:
					total_expense += ingredient_res.price * quantity
					print("Used ", quantity, "x ", ingredient_name, " (", ingredient_res.price, " each)")
				else:
					print("⚠️ Could not load ingredient: ", ingredient_name)

		# Calculate selling price
		total_price += dish.get("price", 0.0) * required_quantity

		# Update dish quantity
		dish["quantity"] -= required_quantity

		# Remove the dish if quantity is 0
		if dish["quantity"] <= 0:
			player_data.dishes.erase(dish_name)

		print("Serving ", required_quantity, " of ", dish_name, " to ", get_clean_customer_name())

	# Update player data with expenses
	player_data.expenses += total_expense
	player_data.order.erase(customer.name)
	player_data.save()

	if total_price <= 0:
		print("No payment needed. Customer has no order.")
		return

	print(get_clean_customer_name(), " paid ", total_price, " coins (Cost: ", total_expense, ")")
	dialogue.set_dialog_text(get_clean_customer_name() + "'s Payment", 
		"Thank you! Here is " + str(total_price) + " coins.\nProfit: " + str(total_price - total_expense))

	has_paid = true
	follow_path(total_price)
	show_order_bubbles(false)
	
func follow_path(total_price: float):
	# Hide UI elements after payment - with null checks
	if dialogue != null:
		dialogue.visible = false
	if take_button != null:
		take_button.visible = false
	if serve_button != null:
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
			test_scene_node.get_node("UI/CanvasLayer/Inventory").populate_inventory_container()
			if has_paid:
				test_scene_node.customer_paid(total_price)
				has_paid = false
		else:
			print("Error: TestScene node not found or missing method!")
	show_order_bubbles(false)
	


func _on_area_2d_body_entered(body: Node2D) -> void:
	print("Body entered:", body.name)  # Debugging: Print
	if body.is_in_group("player"): # Ensure it's the player
		player_in_area = true
		print("Player entered NPC area")
		start_conversation.visible = true
		# Hide thought bubble when player is in area (if order exists)
		if player_data.order.has(customer.name):
			thought_bubble_scene.visible = false

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_in_area = false
		print("Player left NPC area")
		if dialogue != null:
			dialogue.visible = false
		if start_conversation != null:
			start_conversation.visible = false
		if x_button != null:
			x_button.visible = true
		if take_button != null:
			take_button.visible = false
		if serve_button != null:
			serve_button.visible = false
		# Show thought bubble when player exits (if order exists)
		if player_data.order.has(customer.name):
			if thought_bubble_scene != null:
				thought_bubble_scene.visible = true
