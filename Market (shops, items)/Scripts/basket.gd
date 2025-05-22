extends TabBar

@onready var grid_container_2: GridContainer = %GridContainer2
@export var basket_scene: PackedScene
@onready var total_price_label: Label = %TotalPriceLabel
@onready var money_container: PanelContainer = $"../../MoneyContainer"

const INVENTORY_PATH = "res://JSON (dictionaries, data)/player_data.json"
var inventory_data: Dictionary = {}

var basket:Basket = Basket.load_basket()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	# Connect the signal from this specific instance
	basket.basket_updated.connect(update_basket_display)
	update_basket_display()

func update_basket_display():
	update_tab_bar_name()
	# Clear previous items in the UI
	
	for child in grid_container_2.get_children():
		child.queue_free()

	var total_price = 0

	# Iterate through basket items
	for item_name in basket.items.keys():
		var ingredient = basket.items[item_name]
		var basket_instance = basket_scene.instantiate()
		
		print(ingredient)
		

		grid_container_2.add_child(basket_instance)
		basket_instance.set_item_data(ingredient)

		# Calculate total price
		total_price += ingredient["price"] * ingredient["quantity"]

	# Update total price label
	total_price_label.text = str(total_price)
		
		
# Update the TabBar name based on the number of items in the basket
func update_tab_bar_name():
	# Get the total number of items in the basket
	var total_items = 0
	for item in basket.items.values():
		total_items += item["quantity"]
	
	# Update the TabBar name dynamically based on the total items
	self.name = "Basket   " + str(total_items)
	print("TabBar name updated to:", self.name)


# Handle the buy button press
signal purchase_completed(total_cost)
@onready var error_popup: AcceptDialog = %ErrorPopup
var player_data: PlayerData = PlayerData.load_data()

func _on_buy_button_pressed() -> void:
	SoundEffects.play_click()
	print("Buy button Working")
	
	var total_cost = basket.get_total_price()
	
	#player_data.expenses = total_cost
	player_data.save()
	print(total_cost)
	
	print(player_data.budget)
	
	if total_cost > player_data.budget:
		error_popup.dialog_text = "Not enough money!"  # Set the error message
		error_popup.title = "Warning"
		error_popup.popup_centered()  # Show the pop-up in the center
		return  # Stop the function if there's not enough budget

	money_container._on_purchase_completed(total_cost)
	merge_basket_into_inventory()

# Merge basket_data into inventory_data
func merge_basket_into_inventory() -> void:
	var total_cost = basket.get_total_price()

	# Ensure the inventory dictionary exists
	if player_data.inventory == null:
		player_data.inventory = {}  # Create a new dictionary if it doesn't exist

	for item_name in basket.items.keys():
		var ingredient = basket.items[item_name]
		print(ingredient)

		# Update the inventory dictionary inside player_data
		if item_name in player_data.inventory:
			player_data.inventory[item_name]["quantity"] += ingredient["quantity"]
		else:
			player_data.inventory[item_name] = ingredient
	# Emit signal with total cost
	purchase_completed.emit(total_cost)

	for item_name in basket.items.keys():
		basket.remove_item(item_name)  # This also updates the basket JSON
	basket.save_basket()  # Save changes to the basket

	# Save the updated player data
	player_data.save()

		

	
