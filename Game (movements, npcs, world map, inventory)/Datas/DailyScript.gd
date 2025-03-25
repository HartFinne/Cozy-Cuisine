# this script for logic in reseting the game, saving player data files and inventory
# can access and send data via here.

extends Node

const FILE_NAME := "data.json"
const USER_PATH := "user://" + FILE_NAME
const RES_PATH := "res://JSON/" + FILE_NAME

var player_data = {}

func _ready():
	load_data()

func load_data():
	if FileAccess.file_exists(USER_PATH):
		player_data = load_json(USER_PATH)  # Load from user:// (player's save file)
	elif FileAccess.file_exists(RES_PATH):
		player_data = load_json(RES_PATH)  # Load default data from res:// (development only)
		save_json(USER_PATH)  # Copy default data to user://
	else:
		reset_data()  # No file found, initialize new data
		
func load_json(path: String) -> Dictionary:
	var file = FileAccess.open(path, FileAccess.READ)
	if file:
		var content = file.get_as_text()
		if content:
			var parsed_data = JSON.parse_string(content)
			if typeof(parsed_data) == TYPE_DICTIONARY:
				return parsed_data
	return {}  # Ensure a valid return value in all cases
		
func reset_data():
	# Default player data with an empty inventory
	player_data = {
		"budget": 1000,  # Starting money
		"revenue": 0,    # Total income
		"expenses": 0,   # Total spent
		"days": 1,       # Game starts on Day 1
		"inventory": {}   # Empty inventory
		}
	save_data()
	
func save_data():
	save_json(USER_PATH)  # Always save to user:// (persistent)
	
	# Only save to res:// during development
	if OS.is_debug_build():
		save_json(RES_PATH)

func save_json(path: String):
	var file = FileAccess.open(path, FileAccess.WRITE)
	if file:
		file.store_string(JSON.stringify(player_data, "\t"))

# --- Inventory Management ---
func add_item(item_name: String, quantity: int):
	if item_name in player_data["inventory"]:
		player_data["inventory"][item_name] += quantity
	else:
		player_data["inventory"][item_name] = quantity
	save_data()

func remove_item(item_name: String, quantity: int):
	if item_name in player_data["inventory"]:
		player_data["inventory"][item_name] -= quantity
		if player_data["inventory"][item_name] <= 0:
			player_data["inventory"].erase(item_name)  # Remove item if quantity is 0
	save_data()

# --- Financial Updates ---
func update_budget(amount: float):
	player_data["budget"] += amount
	save_data()

func add_revenue(amount: float):
	player_data["revenue"] += amount
	update_budget(amount)

func add_expense(amount: float):
	player_data["expenses"] += amount
	update_budget(-amount)

# --- Day Progression ---
func next_day():
	player_data["days"] += 1
	save_data()
