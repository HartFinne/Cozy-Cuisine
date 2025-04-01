extends StaticBody2D

var cooking_scene = load("res://Cooking (mechanics and ui)/Scenes/cooking_scene.tscn")
const TRIGGER_DISTANCE = 30.0  # Adjust this value as needed
var player_data: PlayerData = PlayerData.load_data()

@onready var main_character: CharacterBody2D = $"../mainCharacter"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not main_character:
		return

	# Check player distance
	var distance = position.distance_to(main_character.position)
	if distance < TRIGGER_DISTANCE and Input.is_action_just_pressed("accept"):
		print("Player is close! Changing scene...")
		
		# ✅ Save position before changing scene
		if player_data:
			player_data.player_position = main_character.global_position
			player_data.save()
			print("✅ Player position saved:", player_data.player_position)
		else:
			print("⚠️ Failed to save position. No player_data found.")

		# ✅ Change scene
		get_tree().change_scene_to_packed(cooking_scene)
