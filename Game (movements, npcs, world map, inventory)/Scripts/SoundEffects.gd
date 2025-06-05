extends Node2D

@onready var click_sfx: AudioStreamPlayer2D = $ClickSFX
@onready var coin_sfx: AudioStreamPlayer2D = $CoinSFX
@onready var done_cooking_sfx: AudioStreamPlayer2D = $DoneCookingSFX
@onready var eod_sfx: AudioStreamPlayer2D = $EodSFX
@onready var transition_sfx: AudioStreamPlayer2D = $TransitionSFX
@onready var start_day_sfx: AudioStreamPlayer2D = $StartDaySFX


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
	
func play_startDay():
	print("Start day sound triggered")
	if start_day_sfx:
		if start_day_sfx.playing:
			start_day_sfx.stop()
		start_day_sfx.play()
	
func play_eod():
	print("EOD sound triggered")
	if eod_sfx:
		if eod_sfx.playing:
			eod_sfx.stop()
		eod_sfx.play()
		
func stop_eod():
	print("Stopping EOD sound")
	if eod_sfx and eod_sfx.playing:
		eod_sfx.stop()
	
func play_transition():
	print("Transition sound triggered")
	if transition_sfx:
		if transition_sfx.playing:
			transition_sfx.stop()
		transition_sfx.play()
