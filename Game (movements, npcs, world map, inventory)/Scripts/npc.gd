extends CharacterBody2D

var player_data: PlayerData = PlayerData.load_data()
@onready var main_character: CharacterBody2D = $"../mainCharacter"
@onready var dialogue: Control = $Dialogue

var player_in_area: bool = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if player_in_area and Input.is_action_just_pressed("accept"):
		dialogue.visible = true
		%StartConversation.visible = false


func _on_area_2d_body_entered(body: Node2D) -> void:
	print("Body entered:", body.name)  # Debugging: Print
	if body.is_in_group("player"): # Ensure it's the player
		player_in_area = true
		print("Player entered NPC area")
		%StartConversation.visible = true
		
func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_in_area = false
		print("Player left NPC area")
		dialogue.visible = false
		%StartConversation.visible = false
