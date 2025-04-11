extends PanelContainer

signal clicked(container)
var dish_name: String
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		emit_signal("clicked", self)


func set_inventory_data(dish_data: Dictionary):
	if dish_data.is_empty():
		%Label.text = ""
		%TextureRect.texture = null
		self.modulate = Color(0.7, 0.7, 0.7, 0.3)  # Optional: make it look grayed out
		return

	%Label.text = str(dish_data.get("quantity", 0))
	%TextureRect.texture = dish_data.get("image")

func get_dish_name() -> String:
	return dish_name
	
	
func set_inventory_ingredients_data(ingredient_data: Dictionary):
	pass
