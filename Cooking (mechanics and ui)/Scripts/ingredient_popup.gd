extends PopupPanel

@onready var v_box_container: VBoxContainer = $VBoxContainer
@export var ingredient_container: PackedScene

var selected_ingredient_slot = null  # Store the clicked ingredient slot
var inventory_data: PlayerData = PlayerData.load_data()

signal ingredient_selected(ingredient_data)  # Signal to send selected ingredient data

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	update_popup_ui()


func show_popup(ingredient_slot):
	print(ingredient_slot, "working")
	selected_ingredient_slot = ingredient_slot  # Store the clicked slot
	visible = true  # Show popup


func update_popup_ui():
	# Clear existing children before adding new ones
	for child in v_box_container.get_children():
		child.queue_free()
	# Add new ingredient names
	if inventory_data.inventory.is_empty():
		var empty_label = Label.new()
		empty_label.text = "Inventory is empty"
		v_box_container.add_child(empty_label)
	else:
		for item_name in inventory_data.inventory.keys():
			var ingredient_data = inventory_data.inventory[item_name]
			
			# Create an instance of the ingredient_container scene to use
			var ingredient_instance = ingredient_container.instantiate()
			
			# Ensure the ingredient_container has a method to set ingredient data
			if ingredient_instance.has_method("set_ingredient_data"):
				ingredient_instance.set_ingredient_data(ingredient_data)
				
			# Connect a click event to send selected ingredient back
			ingredient_instance.connect("gui_input", Callable(self, "_on_ingredient_selected").bind(ingredient_data))
			
			v_box_container.add_child(ingredient_instance)

	print("Popup UI updated with", inventory_data.inventory.size(), "ingredients")
	
func _on_ingredient_selected(event: InputEvent, ingredient_data: Dictionary):
	if event is InputEventMouseButton and event.pressed:
		print("Ingredient selected:", ingredient_data)
		ingredient_selected.emit(ingredient_data)  # Emit the signal with selected data
		# Close popup
		visible = false  
