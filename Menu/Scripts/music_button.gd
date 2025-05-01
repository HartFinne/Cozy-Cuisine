extends TextureButton

@onready var music: HSlider = $"../Music"

var player_data: PlayerData = PlayerData.load_data()

var is_muted := false
var previous_volume := 1.0

func _ready() -> void:
	toggle_mode = true
	pressed.connect(_on_mute_toggled)
	music.value_changed.connect(_on_slider_changed)
	
	music.value = player_data.music_volume

	# Check if music is already muted
	if music.value == 0.0:
		is_muted = true
		button_pressed = true

func _on_mute_toggled() -> void:
	ClickSound.play_click()
	if button_pressed:
		previous_volume = music.value
		music.value = 0.0
		is_muted = true
	else:
		music.value = previous_volume
		is_muted = false

	player_data.music_volume = music.value
	player_data.save()

func _on_slider_changed(value: float) -> void:
	if value > 0.0 and is_muted:
		is_muted = false
		button_pressed = false
	elif value == 0.0 and not is_muted:
		is_muted = true
		button_pressed = true

	player_data.music_volume = value
	player_data.save()
