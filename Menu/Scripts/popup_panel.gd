extends PopupPanel


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	connect("visibility_changed", _on_visibility_changed)

func _on_visibility_changed():
	if not self.visible:
		get_tree().paused = false




func _on_back_button_pressed() -> void:
	$".".hide()
	get_tree().paused = false
	
	pass # Replace with function body.
