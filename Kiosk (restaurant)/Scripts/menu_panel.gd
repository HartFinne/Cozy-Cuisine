extends PopupPanel



func _on_resume_button_pressed() -> void:
	%MenuPanel.hide()
	get_tree().paused = false
	pass # Replace with function body.
	
