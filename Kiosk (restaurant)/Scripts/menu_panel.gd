extends PopupPanel


func _ready() -> void:
	connect("visibility_changed", _on_visibility_changed)

func _on_visibility_changed():
	if not self.visible:
		get_tree().paused = false

func _on_resume_button_pressed() -> void:
	%MenuPanel.hide()
	get_tree().paused = false
	pass # Replace with function body.
	
