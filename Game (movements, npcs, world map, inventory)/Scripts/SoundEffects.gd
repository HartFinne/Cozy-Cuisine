extends Node2D

@onready var click_sfx: AudioStreamPlayer2D = $ClickSFX
@onready var coin_sfx: AudioStreamPlayer2D = $CoinSFX
@onready var done_cooking_sfx: AudioStreamPlayer2D = $DoneCookingSFX


func play_click():
	print("Click sound triggered")
	if click_sfx:
		if click_sfx.playing:
			click_sfx.stop()
		click_sfx.play()
	
func play_coin():
	print("Coin sound triggered")
	if coin_sfx:
		if coin_sfx.playing:
			coin_sfx.stop()
		coin_sfx.play()
	
func play_doneCooking():
	print("Done cooking sound triggered")
	if done_cooking_sfx:
		if done_cooking_sfx.playing:
			done_cooking_sfx.stop()
		done_cooking_sfx.play()
