extends PanelContainer

@onready var texture_rect: TextureRect = %TextureRect
var meal_data

signal meal_selected(meal)

func _ready() -> void:
	texture_rect.connect("gui_input", Callable(self, "_on_gui_input"))
	
func _on_gui_input(event):
	if event is InputEventMouseButton and event.is_pressed():
		print("workings", meal_data)
		emit_signal("meal_selected", meal_data)


func set_data_ui(meal):
	texture_rect = %TextureRect
	meal_data = meal
	texture_rect.texture = meal.image
