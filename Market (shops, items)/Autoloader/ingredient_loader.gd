extends Node

const INGREDIENTS_FILE_PATH = "res://JSON (dictionaries, data)/ingredients_data.json"

var ingredients_data = {}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	load_ingredients()
	pass # Replace with function body.

func load_ingredients():
	if not FileAccess.file_exists(INGREDIENTS_FILE_PATH):
		print("Error: Ingredients file not found at", INGREDIENTS_FILE_PATH)
		return
	
	var file = FileAccess.open(INGREDIENTS_FILE_PATH, FileAccess.READ)
	var json_text = file.get_as_text()
	file.close()
	
	var json = JSON.new()
	var parse_result = json.parse(json_text)
	
	if parse_result == OK:
		ingredients_data = json.data
		print("Ingredients loaded successfully:", ingredients_data.keys())
	else:
		print("Error parsing JSON:", json.get_error_message())
