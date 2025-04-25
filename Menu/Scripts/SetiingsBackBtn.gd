extends TextureButton

@onready var click_sfx: AudioStreamPlayer2D = $"../../ClickSFX"


func _pressed() -> void:
	play_click_sfx()

func play_click_sfx():
	if click_sfx: 
		if click_sfx.playing:
			click_sfx.stop()  
		click_sfx.play()
