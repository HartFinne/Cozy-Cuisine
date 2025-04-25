extends PopupPanel

@onready var grid_container: GridContainer = $"Inventory UI/VBoxContainer/GridContainer"
var inventory_contianer_scene = preload("res://Kiosk (restaurant)/Scenes/Inventory/inventory_container.tscn")
var player_data: PlayerData = PlayerData.load_data()
var dishes = player_data.dishes
@onready var bag_popup_panel: PopupPanel = $"."

var selected_inventory: PanelContainer = null
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	populate_inventory_container()


func populate_inventory_container():
	for child in grid_container.get_children():
		child.queue_free()

	var max_items := 6
	var combined_order := []
	var seen := {}

	# Add from dish_order first
	for dish_name in player_data.dish_order:
		if dishes.has(dish_name) and combined_order.size() < max_items:
			combined_order.append(dish_name)
			seen[dish_name] = true

	# Fill remaining slots with other dishes
	for dish_name in dishes.keys():
		if !seen.has(dish_name) and combined_order.size() < max_items:
			combined_order.append(dish_name)

	# Add inventory containers
	for i in range(max_items):
		var inventory_instance = inventory_contianer_scene.instantiate()

		if i < combined_order.size():
			var dish_name = combined_order[i]
			var dish_data = dishes[dish_name]
			inventory_instance.set_inventory_data(dish_data)
			inventory_instance.connect("clicked", Callable(self, "_on_inventory_clicked"))
		else:
			# Send an empty dictionary to indicate no dish
			inventory_instance.set_inventory_data({})  # Optional: Handle this inside your inventory container

		grid_container.add_child(inventory_instance)





func _on_inventory_clicked(container: PanelContainer) -> void:
	print(container)
	if selected_inventory == null:
		selected_inventory = container
		container.modulate = Color(1, 1, 0.5)
	else:
		var index_a = grid_container.get_children().find(selected_inventory)
		var index_b = grid_container.get_children().find(container)
		
		if index_a != -1 and index_b != -1 and index_a != index_b:
			grid_container.move_child(selected_inventory, index_b)
			grid_container.move_child(container, index_a)
			
			# Save new order in player_data.dish_order
			var new_order: Array = []
			for child in grid_container.get_children():
				if child.has_method("get_dish_name"):
					new_order.append(child.get_dish_name())

			player_data.dish_order = new_order
			player_data.save()
			
		selected_inventory.modulate = Color(1, 1, 1)
		selected_inventory = null


func _on_button_pressed() -> void:
	bag_popup_panel.hide()
	pass # Replace with function body.
