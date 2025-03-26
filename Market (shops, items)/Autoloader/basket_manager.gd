extends Node

const BASKET_PATH = "res://JSON (dictionaries, data)/basket_data.json"
var basket_data: Dictionary = {}  # Now using a dictionary

signal basket_updated  # Emit this when basket changes

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	load_basket_data()
	# print("Loaded basket:", basket_data)

func load_basket_data():
	var file = FileAccess.open(BASKET_PATH, FileAccess.READ)
	if file:
		var json_string = file.get_as_text()
		file.close()
		var data = JSON.parse_string(json_string)
		if typeof(data) == TYPE_DICTIONARY:
			basket_data = data
		else:
			basket_data = {}
	else:
		basket_data = {}
	# print("Basket loaded:", basket_data)
	
func save_basket_data():
	var file = FileAccess.open(BASKET_PATH, FileAccess.WRITE)
	if file:
		file.store_string(JSON.stringify(basket_data, "\t"))
		file.close()

# Add an ingredient to the basket
func add_to_basket(ingredient: Dictionary):
	var item_name = ingredient["name"]
	
	if basket_data.has(item_name):
		# If the item exists, increment the quantity
		basket_data[item_name]["quantity"] += 1
		print("Updated quantity for:", basket_data[item_name])
	else:
		# If the item is new, add it with quantity 1
		basket_data[item_name] = {
			"name": ingredient["name"],
			"price": ingredient["price"],
			"image": ingredient["image"],
			"quantity": 1
		}
		print("Added to basket:", basket_data[item_name])

	save_basket_data()
	basket_updated.emit()
	
func add_quantity(name: String):
	print(name)
	if name in basket_data:
		basket_data[name]["quantity"] += 1
		save_basket_data()
		basket_updated.emit()

func subtract_quantity(name: String):
	if name in basket_data:
		basket_data[name]["quantity"] -= 1
		if basket_data[name]["quantity"] <= 0:
			remove_from_basket(name)  # Remove if zero
		else:
			save_basket_data()
			basket_updated.emit()

func remove_from_basket(name: String):
	basket_data.erase(name)
	save_basket_data()
	basket_updated.emit()
