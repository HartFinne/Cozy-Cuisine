extends TextureButton

@onready var sfx_slider: HSlider = $"../SFX_slider"

var player_data: PlayerData = PlayerData.load_data()

var is_muted := false
var previous_volume := 1.0

func _ready() -> void:
	toggle_mode = true
	pressed.connect(_on_mute_toggled)
	sfx_slider.value_changed.connect(_on_slider_changed)

	sfx_slider.value = player_data.sfx_volume

	if sfx_slider.value == 0.0:
		is_muted = true
		button_pressed = true

func _on_mute_toggled() -> void:
	
	SoundEffects.play_click()

	if button_pressed:
		previous_volume = sfx_slider.value
		sfx_slider.value = 0.0
		is_muted = true
	else:
		sfx_slider.value = previous_volume
		is_muted = false
		
	player_data.sfx_volume = sfx_slider.value
	player_data.save()

func _on_slider_changed(value: float) -> void:
	if value > 0.0 and is_muted:
		is_muted = false
		button_pressed = false
	elif value == 0.0 and not is_muted:
		is_muted = true
		button_pressed = true
	
	player_data.sfx_volume = value
	player_data.save()
