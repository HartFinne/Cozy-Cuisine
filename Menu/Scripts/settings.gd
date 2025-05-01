extends Control

@onready var animation_player: AnimationPlayer = $AnimationPlayer



func _on_back_pressed() -> void:	
	ClickSound.play_click()
	animation_player.play_backwards("blur")
	get_tree().paused = false
	queue_free() 
