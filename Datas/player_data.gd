extends Resource
class_name PlayerData

@export var budget: float = 1000.0
@export var days: float = 1.0
@export var expenses: float = 0.0
@export var inventory: Dictionary = {}
@export var profit: float = 0.0
@export var revenue: float = 0.0
@export var total_profit: float = 0.0

# Save the player data as a resource file
func save(file_path: String = "user://player_data.tres"):
	ResourceSaver.save(self, file_path)

# Load player data from a resource file
static func load_data(file_path: String = "user://player_data.tres") -> PlayerData:
	if ResourceLoader.exists(file_path):
		return ResourceLoader.load(file_path) as PlayerData
	return PlayerData.new()  # Return default if file doesn't exist

static func print_hello_workd():
	print("hello")
