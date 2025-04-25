extends Control

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var click_sfx: AudioStreamPlayer2D = $ClickSFX



func _on_back_pressed() -> void:	
	play_click_sfx()
	animation_player.play_backwards("blur")
	get_tree().paused = false
	queue_free() 
func play_click_sfx():
	if click_sfx: 
		if click_sfx.playing:
			click_sfx.stop()  
		click_sfx.play()
