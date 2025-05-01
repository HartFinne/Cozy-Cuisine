extends HBoxContainer

var inventory_contianer_scene = preload("res://Kiosk (restaurant)/Scenes/Inventory/inventory_container.tscn")
var player_data: PlayerData = PlayerData.load_data()
var dishes = player_data.dishes


@onready var grid_container: GridContainer = %GridContainer
@onready var grid_container1: GridContainer = $PopupPanel/VBoxContainer/GridContainer
@onready var bag_popup_panel: PopupPanel = $BagPopupPanel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	populate_inventory_container()
	pass # Replace with function body.
	
func populate_inventory_container():
	for child in grid_container.get_children():
		child.queue_free()
		
	var count := 0
	
	for dish_name in dishes.keys():
		if count >= 4:
			break
		var dish_data = dishes[dish_name]
		var inventory_instance = inventory_contianer_scene.instantiate()
		
		if inventory_instance.has_method("set_inventory_data"):
			inventory_instance.set_inventory_data(dish_data)
			
		grid_container.add_child(inventory_instance)

func _on_bag_button_pressed() -> void:
	ClickSound.play_click()
	bag_popup_panel.show()
	print("working")
