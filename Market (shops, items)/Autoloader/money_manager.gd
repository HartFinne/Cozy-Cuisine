extends Node

const PLAYER_DATA_PATH = "res://JSON (dictionaries, data)/player_data.json"

var budget: float = 0.0  # Store budget in memory


func load_player_data():
	var file = FileAccess.open(PLAYER_DATA_PATH, FileAccess.READ)
	if file:
		var json_string = file.get_as_text()
		file.close()
		var data = JSON.parse_string(json_string)
		if typeof(data) == TYPE_DICTIONARY and "budget" in data:
			budget = data["budget"]


		
func deduct_money(total_cost: float):
	budget -= total_cost
	save_player_money_data()
	
# Save updated budget to JSON
func save_player_money_data():
	var file = FileAccess.open(PLAYER_DATA_PATH, FileAccess.READ)
	var data = {}

	if file:
		var json_string = file.get_as_text()
		file.close()
		data = JSON.parse_string(json_string)

	# Ensure data structure remains intact
	if typeof(data) != TYPE_DICTIONARY:
		data = {}

	data["budget"] = budget  # Update budget

	file = FileAccess.open(PLAYER_DATA_PATH, FileAccess.WRITE)
	if file:
		file.store_string(JSON.stringify(data, "\t"))  # Save with formatting
		file.close()
