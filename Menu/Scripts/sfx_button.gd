extends TextureButton

@onready var sfx_slider: HSlider = $"../SFX_slider"
@onready var click_sfx: AudioStreamPlayer2D = $"../../ClickSFX"


var is_muted := false
var previous_volume := 1.0

func _ready() -> void:
	toggle_mode = true
	pressed.connect(_on_mute_toggled)
	sfx_slider.value_changed.connect(_on_slider_changed)

func _on_mute_toggled() -> void:
	
	play_click_sfx()

	if button_pressed:
		previous_volume = sfx_slider.value
		sfx_slider.value = 0.0
		is_muted = true
	else:
		sfx_slider.value = previous_volume
		is_muted = false

func _on_slider_changed(value: float) -> void:
	if value > 0.0 and is_muted:
		is_muted = false
		button_pressed = false


func play_click_sfx():
	if click_sfx: 
		if click_sfx.playing:
			click_sfx.stop()  
		click_sfx.play() 
