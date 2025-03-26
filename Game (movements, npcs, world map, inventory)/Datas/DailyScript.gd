# this script for logic in reseting the game, saving player data files and inventory
# can access and send data via here.
extends Node

const FILE_NAME := "player_data.json"
const USER_PATH := "user://" + FILE_NAME
const RES_PATH := "res://JSON (dictionaries, data)/" + FILE_NAME  # Used only in development

var player_data = {}

func _ready():
	print("DailyScript _ready() called")  # Debugging
	load_data()

func load_data():
	print("load_data() called")  # Debugging
	if FileAccess.file_exists(USER_PATH):
		print("User file exists:", USER_PATH)
		player_data = load_json(USER_PATH)
	elif FileAccess.file_exists(RES_PATH):
		print("Res file exists:", RES_PATH)
		player_data = load_json(RES_PATH)
		save_json(USER_PATH)  # Copy default data to user://
	else:
		print("No save file found, resetting data")
		reset_data()

#func load_json(path: String) -> Dictionary:
	#var file = FileAccess.open(path, FileAccess.READ)
	#if file:
		#var content = file.get_as_text()
		#if content:
			#var parsed_data = JSON.parse_string(content)
			#if typeof(parsed_data) == TYPE_DICTIONARY:
				#return parsed_data
	#return {}
	
func load_json(path: String) -> Dictionary:
	print("🔍 Attempting to load JSON from:", path)
	
	if not FileAccess.file_exists(path):
		print("❌ ERROR: File does not exist:", path)
		return {}

	var file = FileAccess.open(path, FileAccess.READ)
	if file == null:
		print("❌ ERROR: Could not open file:", path)
		return {}

	var content = file.get_as_text()
	print("📂 File content:", content)

	if content.is_empty():
		print("❌ ERROR: File is empty!")
		return {}

	var parsed_data = JSON.parse_string(content)
	
	if parsed_data == null or typeof(parsed_data) != TYPE_DICTIONARY:
		print("❌ ERROR: JSON parsing failed or data is not a dictionary!")
		return {}

	print("✅ Successfully loaded JSON data:", parsed_data)
	return parsed_data
	
func reset_data():
	player_data = {
		"budget": 1000,  # Starting money
		"revenue": 0,    # Daily income
		"expenses": 0,   # Daily expenses
		"profit": 0,     # Daily profit (revenue - expenses)
		"total_profit": 0, # Tracks profit over all days
		"days": 1,       # Game starts on Day 1
		"inventory": {}   # Empty inventory
	}
	save_data()		

func save_data():
	save_json(USER_PATH)
	if OS.is_debug_build():
		print("on debug build mode")
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
			player_data["inventory"].erase(item_name)
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

# --- End-of-Day Calculation ---
func process_end_of_day():
	player_data["profit"] = player_data["revenue"] - player_data["expenses"]
	player_data["total_profit"] += player_data["profit"]
	player_data["revenue"] = 0
	player_data["expenses"] = 0
	player_data["days"] += 1
	save_data()

	print("End of Day Summary:")
	print("Day:", player_data["days"] - 1)
	print("Profit:", player_data["profit"])
	print("Total Profit:", player_data["total_profit"])
	print("Remaining Budget:", player_data["budget"])
