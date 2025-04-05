extends Node2D

@onready var panel_container_2: PanelContainer = $Control/CanvasLayer/PanelContainer2
@onready var h_box_container: HBoxContainer = %HBoxContainer

var market_scene = load("res://Market (shops, items)/Scenes/market_scene.tscn")
var player_data: PlayerData = PlayerData.load_data()
@export var customers: Array = []
@onready var touch_controls: CanvasLayer = $UI/TouchControls
@onready var money_container: PanelContainer = $UI/CanvasLayer/MoneyContainer


@onready var paths := [
	$Path2D/PathFollow2D, 
	$Path2D2/PathFollow2D, 
	$Path2D3/PathFollow2D, 
	$Path2D4/PathFollow2D, 
	$Path2D5/PathFollow2D
]  # ✅ Store all PathFollow2D nodes

var customer_scene = preload("res://Game (movements, npcs, world map, inventory)/Scenes/NPC/vip_boy.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	money_container.update_money_ui()
	## Clear customers array before loading new data
	#customers.clear()
	#
	## Load saved customer data if any
	#var saved_customers = GameData.load_customers()
	#if saved_customers:
		#for data in saved_customers:
			#var customer_instance = load(data["scene"]).instantiate()
			#var path = paths[data["path_index"]]  # Find the path using path_index
			#print(paths, "paths to")
			#print(path, "path eto")
			#if path:
				#path.add_child(customer_instance)
				#path.progress = data["progress"]  # Set the progress instead of position
				#
				## Apply the rotation and scale from the saved data
				#customer_instance.rotation_degrees = data["rotation"]  # Set the rotation
				#customer_instance.scale = Vector2(2.0, 2.0)  # Set the scale
				#
#
				## Set customer to follow the path from the correct position
				#move_customer_along_path(path, customer_instance, data["path_index"], path, customer_instance)
				#
			#else:
				#print("Invalid path index for customer!")
	
	if h_box_container:
		h_box_container.mouse_filter = Control.MOUSE_FILTER_STOP  # ✅ Allow it to receive input
	else:
		print("hbox not seen")
	if player_data:  # ✅ Check if data is loaded
		var player = get_node_or_null("mainCharacter")  # Make sure the node exists
		if player:
			player.global_position = player_data.player_position  # ✅ Restore last position
	else:
		print("⚠️ Player data failed to load!")

	spawn_customers_with_intervals()
	
func spawn_customers_with_intervals():
	for i in range(5):
		await get_tree().create_timer(i * 2).timeout
		spawn_customer_on_random_path()
	
func spawn_customer_on_random_path():
	# Get a list of available (empty) paths
	var available_paths = paths.filter(func(path): return path.get_child_count() == 0)  # Only paths with no customers

	if available_paths.size() == 0:
		print("⚠️ No available paths for customers!")
		return
	
	# Pick a random available path
	var random_path = available_paths.pick_random()
	
	# Check that we picked a valid path
	if customer_scene and random_path:
		var customer_instance = customer_scene.instantiate()
		random_path.add_child(customer_instance)
		
		customer_instance.scale = Vector2(2.0, 2.0)
		customer_instance.rotation_degrees = -180  # Adjust rotation
		
		# Initialize the customer's position on the path (start point)
		random_path.progress = 0.0


		# Use index to find the correct path index
		var path_index = paths.find(random_path)
		# Move customer along the path
		move_customer_along_path(random_path, customer_instance, path_index, customer_instance)
		
	else:
		print("⚠️ Customer resource failed to load or invalid path")

		
func move_customer_along_path(path_follow: PathFollow2D, customer, path_index, customer_instance):
	var tween = get_tree().create_tween()
	tween.tween_property(path_follow, "progress", 527.22, 3.0).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	
	await tween.finished
	print("Customer stopped at counter: ", path_follow)
	
	# Notify the npc script that they reached the counter
	if customer.has_method("reach_counter"):
		customer.reach_counter(path_follow)
		
	var customer_data = {
			"path_index": float(path_index),  # Store path index
			"progress": path_follow.progress,  # Store progress instead of global position
			"scene": customer_scene.resource_path,
			"rotation_degrees": customer_instance.rotation_degrees,
		}
		# Append to GameData's customers_data
	customers.append(customer_data)  # Append to the GameData array
		

func resume_customer_movement(path_follow: PathFollow2D):
	money_container.update_money_ui()
	var tween = get_tree().create_tween()
	tween.tween_property(path_follow, "progress", 1000, 3.0).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	
	await tween.finished  # Wait for tween to complete
	
	# Remove customer from path after leaving
	if path_follow.get_child_count() > 0:
		var customer = path_follow.get_child(0)
		customer.queue_free()             # Free instance to allow new one
		await get_tree().process_frame
		
	# Allow new customers to spawn on this path
	spawn_customer_on_random_path()
	
	print("Customer leaves after payment")


func _on_h_box_container_gui_input(event: InputEvent) -> void:
	if (event is InputEventMouseButton and event.is_pressed()) or (event is InputEventScreenTouch and event.pressed):
	   
		SceneManager.touch_controls = get_node("UI/TouchControls")
		SceneManager.canvas_layer = get_node("UI/CanvasLayer")
		SceneManager.gameplay_scene = get_tree().current_scene
		SceneManager.go_to_market()
			
			
			



func _on_pause_button_pressed() -> void:
	get_tree().paused = true
	%MenuPanel.show()
	pass
	
