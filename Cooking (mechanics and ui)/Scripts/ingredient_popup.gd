extends PopupPanel

@onready var label: Label = $VBoxContainer/Label
@onready var v_box_container: VBoxContainer = $VBoxContainer

var selected_ingredient_slot = null  # Store the clicked ingredient slot
var inventory_data: PlayerData = PlayerData.load_data()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	update_popup_ui()


func show_popup(ingredient_slot):
	print(ingredient_slot)
	selected_ingredient_slot = ingredient_slot  # Store the clicked slot
	visible = true  # Show popup


func update_popup_ui():
	# Add new ingredient names
	if inventory_data.inventory.is_empty():
		var empty_label = Label.new()
		empty_label.text = "Inventory is empty"
		v_box_container.add_child(empty_label)
	else:
		for item_name in inventory_data.inventory.keys():
			var ingredient = inventory_data.inventory[item_name]
			
			# Create a label for each ingredient
			var ingredient_label = Label.new()
			ingredient_label.text = "- %s (x%d)" % [ingredient.name, ingredient.quantity]
			v_box_container.add_child(ingredient_label)

	print("Popup UI updated with", inventory_data.inventory.size(), "ingredients")
	
	
