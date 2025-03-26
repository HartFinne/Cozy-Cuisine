extends Control

@onready var texture_rect = $TextureRect  # Get reference to the TextureRect
var popup_scene = preload("res://Game (movements, npcs, world map, inventory)/Scenes/EndOfDayPopUp.tscn")

func _ready():
	texture_rect.mouse_filter = Control.MOUSE_FILTER_STOP  # Allow click detection
	
func _on_texture_rect_gui_input(event):
	if event is InputEventMouseButton and event.pressed:
		print("✅ End-of-Day Button Clicked (Mouse or Touch)!")
		var popup_instance = popup_scene.instantiate()
		get_tree().current_scene.add_child(popup_instance)
		popup_instance.update_popup()  # Now update the labels
