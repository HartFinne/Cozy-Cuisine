extends PanelContainer

@onready var texture_rect: TextureRect = %TextureRect
var ingredient_data

signal ingredient_selected(ingredient)

func _ready() -> void:
	texture_rect.connect("gui_input", Callable(self, "_on_gui_input"))
	pass
	
func _on_gui_input(event):
	if event is InputEventMouseButton and event.is_pressed():
		print("workings", ingredient_data)
		emit_signal("ingredient_selected", ingredient_data)

func set_data_ui(ingredient):
	ingredient_data = ingredient
	texture_rect = %TextureRect
	texture_rect.texture = ingredient.image
