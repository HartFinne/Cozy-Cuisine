extends Control


var dialog = []
var current_index = 0
var is_next_dialog: bool = false


func _ready() -> void:
	pass
	
func set_dialog_text(text: String, text2: String):
	%NameLabel.text = text
	%DialogueLabel.text = text2
