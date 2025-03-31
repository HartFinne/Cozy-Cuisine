extends Control


var world_scene = load("res://Kiosk (restaurant)/Scenes/testing_scene.tscn")

func _on_start_button_pressed() -> void:
	if world_scene:
		get_tree().change_scene_to_packed(world_scene)
	else:
		print("Failed to load")
	print("Start Button")
	
func _on_tutorial_button_pressed() -> void:
	print("Tutorialssss")
	
func _on_quit_button_pressed() -> void:
	
	print("quit button")
