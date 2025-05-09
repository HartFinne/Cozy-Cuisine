extends Node2D

@onready var panel_container_2: PanelContainer = $Control/CanvasLayer/PanelContainer2
@onready var h_box_container: HBoxContainer = %HBoxContainer

var market_scene = load("res://Market (shops, items)/Scenes/market_scene.tscn")
var player_data: PlayerData = PlayerData.load_data()
@export var customers: Array = []
@onready var touch_controls: CanvasLayer = $UI/TouchControls
@onready var money_container: PanelContainer = $UI/CanvasLayer/MoneyContainer
@onready var coin_sfx: AudioStreamPlayer2D = $CoinSFX

@onready var tutorial_scene: Control = $UI/CanvasLayer/TutorialScene

@onready var goal_label: Label = %GoalLabel
@onready var goal_container: PanelContainer = $UI/CanvasLayer/GoalContainer

@onready var start_day_button: Button = %StartDayButton
var is_day_ended = false

var revenue = 0
var profit = 0
var expenses = 0

@onready var end_of_day: PopupPanel = $UI/CanvasLayer/EndOfDay

@onready var panel_label_1: Label = $UI/CanvasLayer/PanelContainer/Button/HBoxContainer/Label
@onready var panel_label_2: Label = $UI/CanvasLayer/PanelContainer2/HBoxContainer/Label

@onready var paths := [
	#$Path2D/PathFollow2D, 
	$Path2D2/PathFollow2D, 
	$Path2D3/PathFollow2D, 
	$Path2D4/PathFollow2D, 
	#$Path2D5/PathFollow2D
]  # ✅ Store all PathFollow2D nodes



var customer_scene = [
	preload("res://Game (movements, npcs, world map, inventory)/Scenes/NPC/vip_boy.tscn"),
	preload("res://Game (movements, npcs, world map, inventory)/Scenes/NPC/vip_girl.tscn"),
	preload("res://Game (movements, npcs, world map, inventory)/Scenes/NPC/customer_young.tscn"),
	preload("res://Game (movements, npcs, world map, inventory)/Scenes/NPC/customer_old.tscn"),
	preload("res://Game (movements, npcs, world map, inventory)/Scenes/NPC/customer_male.tscn")
]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if !player_data.is_tutorial_watched:
		touch_controls.visible = false
		tutorial_scene.visible = true
		tutorial_scene.connect("tutorial_finished", Callable(self, "_on_tutorial_finished"))
		
	
	h_box_container.mouse_filter = Control.MOUSE_FILTER_STOP  # ✅ Allow it to receive input

	if player_data:  # ✅ Check if data is loaded
		var player = get_node_or_null("mainCharacter")  # Make sure the node exists
		if player:
			player.global_position = player_data.player_position  # ✅ Restore last position
	else:
		print("⚠️ Player data failed to load!")

	goal_container.visible = false

	start_day_button.pressed.connect(start_day)

	start_and_goal_update_ui()
	
func _on_tutorial_finished():
	tutorial_scene.visible = false
	touch_controls.visible = true
	player_data.is_tutorial_watched = true
	player_data.save()
	
func start_day():
	ClickSound.play_click()
	player_data.revenue = 0
	player_data.expenses = 0
	player_data.profit = 0
	
	player_data.order = {}
	
	start_day_button.visible = false
	goal_container.visible = true
	
	panel_label_1.visible = false
	panel_label_2.visible = false

	spawn_customers_with_intervals()

	
func start_and_goal_update_ui():
	start_day_button.text = "Start Day " + str(int(player_data.days))
	
	goal_label.text = "Profit Goal: " + str(int(profit)) + " / " + str(int(player_data.goal_profit_per_day))
	
	
func customer_paid(amount: int):
	expenses = player_data.expenses
	
	revenue += amount
	profit = revenue - expenses
	
	player_data.revenue = revenue
	player_data.profit = profit
	
	coin_sfx.play()
	
	start_and_goal_update_ui()
	check_if_day_should_end()
	
func check_if_day_should_end():
	if player_data.profit >= player_data.goal_profit_per_day:
		end_day()
		
func end_day():
	start_and_goal_update_ui()
	is_day_ended = true
	player_data.days += 1
	player_data.goal_profit_per_day += 50
	player_data.save()
	
	get_tree().paused = true
	end_of_day.show()
	end_of_day.set_testing_script(self)
	end_of_day.end_day_update_ui()
	
	panel_label_1.visible = true
	panel_label_2.visible = true
	
	revenue = 0
	profit = 0
	expenses = 0
	
	print("Day ended, is_day_ended = ", is_day_ended)  # Debugging line
	
	
func spawn_customers_with_intervals():
	for i in range(5):
		await get_tree().create_timer(i * 2).timeout
		spawn_customer_on_random_path()
	
func spawn_customer_on_random_path():
	if is_day_ended:
		return
	# Get a list of available (empty) paths
	var available_paths = paths.filter(func(path): return path.get_child_count() == 0)  # Only paths with no customers

	if available_paths.size() == 0:
		print("⚠️ No available paths for customers!")
		return
	
	# Pick a random available path
	var random_path = available_paths.pick_random()
	
	
	var selected_customer_scene = customer_scene.pick_random()
	# Check that we picked a valid path
	if selected_customer_scene and random_path:
		var customer_instance = selected_customer_scene.instantiate()
		customer_instance.customer = customer_instance.customer.duplicate(true)
		
		var unique_customer = str(Time.get_ticks_msec())
		customer_instance.customer.name += "_" + unique_customer
		
		
		random_path.add_child(customer_instance)
		
		customer_instance.scale = Vector2(2.0, 2.0)
		customer_instance.rotation_degrees = -180  # Adjust rotation
		
		# Initialize the customer's position on the path (start point)
		random_path.progress = 0.0


		# Use index to find the correct path index
		var path_index = paths.find(random_path)
		
		# Move customer along the path
		move_customer_along_path(random_path, customer_instance, path_index, selected_customer_scene)
		
	else:
		print("⚠️ Customer resource failed to load or invalid path")



func move_customer_along_path(path_follow: PathFollow2D, customer, path_index, selected_customer_scene):
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
			"scene": selected_customer_scene.resource_path,
			"rotation_degrees": customer.rotation_degrees,
		}
		# Append to GameData's customers_data
	customers.append(customer_data)  # Append to the GameData array
		

func resume_customer_movement(path_follow: PathFollow2D):
	money_container.update_money_ui()

	if path_follow.get_child_count() > 0:
		var customer = path_follow.get_child(0)
		
		# Flip customer horizontally (face the exit)
		customer.scale.x = -abs(customer.scale.x)

		# Optionally flip rotation if needed (usually not necessary if scale handles it)
		customer.rotation_degrees = 180  # Adjust as needed based on your setup

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
		ClickSound.play_click()
		SceneManager.touch_controls = get_node("UI/TouchControls")
		SceneManager.canvas_layer = get_node("UI/CanvasLayer")
		SceneManager.gameplay_scene = get_tree().current_scene
		SceneManager.go_to_market()
			
			

func _on_button_pressed() -> void:
	ClickSound.play_click()
	SceneManager.touch_controls = get_node("UI/TouchControls")
	SceneManager.canvas_layer = get_node("UI/CanvasLayer")
	SceneManager.gameplay_scene = get_tree().current_scene
	SceneManager.go_to_cook_book()



func _on_pause_button_pressed() -> void:
	ClickSound.play_click()
	get_tree().paused = true
	%MenuPanel.show()
	pass
	
