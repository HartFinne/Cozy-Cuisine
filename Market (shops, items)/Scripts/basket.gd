extends TabBar

@onready var grid_container_2: GridContainer = %GridContainer2
@export var basket_scene: PackedScene

@onready var total_price_label: Label = %TotalPriceLabel

const INVENTORY_PATH = "res://JSON (dictionaries, data)/player_data.json"
var inventory_data: Dictionary = {}

var basket_data

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	update_basket_display()


func update_basket_display():
	for child in grid_container_2.get_children():
		child.queue_free()
		
	
	basket_data = BasketManager.basket_data
	var total_price = 0
	
	# print("11111111")
	# print(basket_data)
	
	for item_name in basket_data.keys():
		var ingredient = basket_data[item_name]
		# print(ingredient)
		var basket_instance = basket_scene.instantiate()
		
		grid_container_2.add_child(basket_instance)
		basket_instance.set_item_data(ingredient)
		
		# Calculate total price
		total_price += ingredient["price"] * ingredient["quantity"]
	
	# Update total price label
	total_price_label.text = str(total_price)
	BasketManager.basket_updated.connect(update_basket_display)  # Listen for changes
		
		
# Handle the buy button press
signal purchase_completed(total_cost)
@onready var error_popup: AcceptDialog = %ErrorPopup

func _on_buy_button_pressed() -> void:
	load_inventory_data()
	print("Buy button Working")
	
	var total_cost = calculate_total_cost()
	
	if total_cost > MoneyManager.budget:
		error_popup.dialog_text = "Not enough money!"  # Set the error message
		error_popup.title = "Warning"
		error_popup.popup_centered()  # Show the pop-up in the center
		return  # Stop the function if there's not enough budget

	merge_basket_into_inventory()
	save_inventory_data()

# Calculate total cost before purchase
func calculate_total_cost() -> float:
	var total_cost = 0
	for item_name in basket_data.keys():
		var ingredient = basket_data[item_name]
		total_cost += ingredient["price"] * ingredient["quantity"]
	return total_cost

# Merge basket_data into inventory_data
func merge_basket_into_inventory() -> void:
	var total_cost = calculate_total_cost()
	for item_name in basket_data.keys():
		var ingredient = basket_data[item_name]
		if item_name in inventory_data:
			inventory_data[item_name]["quantity"] += ingredient["quantity"]
		else:
			inventory_data[item_name] = ingredient
			
		total_cost += ingredient["price"] * ingredient["quantity"]
	
	# Emit signal with total cost
	purchase_completed.emit(total_cost)
	# Remove all items from the basket using BasketManager
	for item_name in basket_data.keys():
		BasketManager.remove_from_basket(item_name)  # This also updates the basket JSON
		

# Load player inventory from file
func load_inventory_data() -> void:
	var file = FileAccess.open(INVENTORY_PATH, FileAccess.READ)
	if file:
		var data = JSON.parse_string(file.get_as_text())
		file.close()
		
		if typeof(data) == TYPE_DICTIONARY:
			inventory_data = data.get("inventory", {})
	else:
		inventory_data = {}

# Save updated inventory back to file without modifying other values
func save_inventory_data() -> void:
	var existing_data = load_full_player_data()
	print("save inventory")
	# print(existing_data)
	existing_data["inventory"] = inventory_data  # Update only inventory

	var file = FileAccess.open(INVENTORY_PATH, FileAccess.WRITE)
	if file:
		file.store_string(JSON.stringify(existing_data, "\t"))
		file.close()

# Load full player data to preserve other fields
func load_full_player_data() -> Dictionary:
	var file = FileAccess.open(INVENTORY_PATH, FileAccess.READ)
	if file:
		var data = JSON.parse_string(file.get_as_text())
		file.close()
		if typeof(data) == TYPE_DICTIONARY:
			return data
	return {}  # Default empty dictionary if file doesn't exist or is corrupted

	
