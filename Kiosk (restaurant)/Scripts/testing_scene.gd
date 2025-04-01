extends Node2D

@onready var panel_container_2: PanelContainer = $Control/CanvasLayer/PanelContainer2
@onready var h_box_container: HBoxContainer = %HBoxContainer

var market_scene = load("res://Market (shops, items)/Scenes/market_scene.tscn")
var player_data: PlayerData = PlayerData.load_data()
@export var customers: Dictionary = {}



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	h_box_container.mouse_filter = Control.MOUSE_FILTER_STOP  # ✅ Allow it to receive input
	if player_data:  # ✅ Check if data is loaded
		var player = get_node_or_null("mainCharacter")  # Make sure the node exists
		if player:
			player.global_position = player_data.player_position  # ✅ Restore last position
	else:
		print("⚠️ Player data failed to load!")
		
	  # ✅ Make sure there's a customer to spawn
	print("Customers:", customers)
	spawn_customers()
	
# Spawn the customers
# ✅ Load and spawn customers without player_data
func spawn_customers():
	var spawn_positions = [Vector2(1000, 224.0)]  # Example position

	# ✅ Load customer manually
	var customer_res = preload("res://Datas/Resources/Customer/rich_boy.tres")

	if customer_res:
		spawn_customer(customer_res, spawn_positions[0])  # ✅ Pass manually loaded customer
	else:
		print("⚠️ Customer resource failed to load!")
		

# ✅ Spawn a single customer and move them to the counter
func spawn_customer(customer: Customer, position: Vector2):
	if customer.character_scene:
		var customer_instance = customer.character_scene.instantiate()
		add_child(customer_instance)

		customer_instance.position = position
		customer_instance.set_meta("customer_data", customer)
		customer_instance.scale = Vector2(2.0, 2.0)

		# ✅ Define the counter position
		var counter_position = Vector2(696.0, 240.0)  # Adjust as needed

		# ✅ Create a Tween node for smooth movement
		var tween = get_tree().create_tween()
		tween.tween_property(customer_instance, "position", counter_position, 2.0).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

		print("🚶 Customer is moving to the counter...")


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
			
