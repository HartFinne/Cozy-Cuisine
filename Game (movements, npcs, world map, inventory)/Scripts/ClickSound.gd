extends Node2D

@onready var click_sfx: AudioStreamPlayer2D = $ClickSFX

func play_click():
	print("ClickSound triggered")
	if click_sfx:
		print("ClickSFX node found")
		if click_sfx.playing:
			click_sfx.stop()
		click_sfx.play()
