extends Node2D

@onready var panel_container_2: PanelContainer = $Control/CanvasLayer/PanelContainer2
@onready var h_box_container: HBoxContainer = %HBoxContainer

var market_scene = load("res://Market (shops, items)/Scenes/market_scene.tscn")
var player_data: PlayerData = PlayerData.load_data()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	h_box_container.mouse_filter = Control.MOUSE_FILTER_STOP  # ✅ Allow it to receive input
	if player_data:  # ✅ Check if data is loaded
		var player = get_node_or_null("mainCharacter")  # Make sure the node exists
		if player:
			player.global_position = player_data.player_position  # ✅ Restore last position
	else:
		print("⚠️ Player data failed to load!")

func _on_h_box_container_gui_input(event: InputEvent) -> void:
	if (event is InputEventMouseButton and event.is_pressed()) or (event is InputEventScreenTouch and event.pressed):
	   
		var player = get_node_or_null("mainCharacter")  
		if player and player_data:
			player_data.player_position = player.global_position  # ✅ Save position
			player_data.save()  # ✅ Save to file
		else:
			print("⚠️ Failed to save position. Player or data missing!")

		# ✅ Ensure scene switch only if market_scene is loaded
		if market_scene:
			get_tree().change_scene_to_packed(market_scene)  
		else:
			print("❌ Market scene failed to load!")
