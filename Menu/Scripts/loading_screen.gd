extends Control

@onready var texture_progress_bar: TextureProgressBar = $TextureProgressBar
@onready var percentage: Label = $Percentage
@onready var loading_bar: AnimatedSprite2D = $LoadingBarAnimated

var scene_path: String = "res://Menu/Scenes/main_screen.tscn"
var progress := [0.0]
var update := 0.0
var loading_started := false
var show_100_briefly := false
var wait_timer := 0.0

# Total number of frames in your loading bar animation
var total_frames := 10

func _ready() -> void:
	texture_progress_bar.value = 0.0
	percentage.text = "0 %"
	await get_tree().create_timer(0.5).timeout  # Optional delay
	ResourceLoader.load_threaded_request(scene_path)
	loading_started = true

func _process(delta: float) -> void:
	if not loading_started:
		return

	var status = ResourceLoader.load_threaded_get_status(scene_path, progress)
	if status == ResourceLoader.THREAD_LOAD_FAILED:
		push_error("Failed to load scene!")
		return

	update = progress[0]
	texture_progress_bar.value = lerp(texture_progress_bar.value, update, delta * 5)

	# Ensure bar reaches exactly 1.0
	if status == ResourceLoader.THREAD_LOAD_LOADED and texture_progress_bar.value >= 0.99:
		texture_progress_bar.value = 1.0
		if not show_100_briefly:
			show_100_briefly = true
			wait_timer = 0.5  # Show 100% for 0.5 seconds

	if show_100_briefly:
		wait_timer -= delta
		if wait_timer <= 0.0:
			get_tree().change_scene_to_packed(ResourceLoader.load_threaded_get(scene_path))
		return  # Pause here to show 100%

	# Update percentage text (ensure we show 100%)
	var display_percent := int(texture_progress_bar.value * 100.0)
	percentage.text = str(display_percent) + " %"

	# Animate loading bar frame
	if is_instance_valid(loading_bar) and loading_bar.sprite_frames:
		var frame_index = int(clamp(texture_progress_bar.value * total_frames, 0, total_frames - 1))
		loading_bar.frame = frame_index
