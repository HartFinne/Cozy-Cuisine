extends Node

const SAVE_PATH = "user://customers_data.json"

var customers_data = []

# Save customers to JSON file
func save_customers(customers):
	customers_data.clear()
	var existing_path_indexes = []  # Store existing path indexes to prevent duplicates

	# Load existing customers to avoid duplication
	var loaded_customers = load_customers()
	for customer in loaded_customers:
		existing_path_indexes.append(customer["path_index"])  # Track existing path indexes

	for customer in customers:
		# Validate if this path_index already exists in the saved data
		if customer.path_index in existing_path_indexes:
			print("⚠️ Duplicate entry detected for path_index:", customer.path_index, "Skipping save.")
			continue  # Skip saving duplicate customers
		
		customers_data.append({
			"scene": customer.scene,  
			"progress": customer.progress,  
			"path_index": customer.path_index,  
			"rotation": customer.rotation_degrees,
		})
		
		existing_path_indexes.append(customer.path_index)  # Add new index to tracking list

	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file:
		file.store_string(JSON.stringify(customers_data))
		file.close()
		print("✅ Customer data saved successfully!")
	else:
		print("❌ Failed to save customer data.")

		
# Load customers from JSON file
func load_customers():
	if not FileAccess.file_exists(SAVE_PATH):
		print("⚠️ No customer data found, returning empty list.")
		return []
		
	var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
	if file:
		var content = file.get_as_text()
		file.close()

		var json = JSON.new()
		var parse_result = json.parse(content)

		if parse_result == OK:
			customers_data = json.data
			print("✅ Customer data loaded successfully!")
			return customers_data
		else:
			print("❌ Failed to parse customer JSON file.")
			return []
	else:
		print("❌ Failed to load customer data.")
		return []
		
