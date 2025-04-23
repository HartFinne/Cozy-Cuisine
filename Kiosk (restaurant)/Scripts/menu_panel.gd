extends PopupPanel

var main_scene = preload("res://Menu/Scenes/main_screen.tscn")
var loading_scene = preload("res://Menu/Scenes/loading_screen.tscn")

func _ready() -> void:
	connect("visibility_changed", _on_visibility_changed)

func _on_visibility_changed():
	if not self.visible:
		get_tree().paused = false

func _on_resume_button_pressed() -> void:
	%MenuPanel.hide()
	get_tree().paused = false
	pass # Replace with function body.
	


func _on_quit_button_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_packed(loading_scene)
