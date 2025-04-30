extends AnimatedSprite2D

@onready var loading_bar: AnimatedSprite2D = $"Control/$LoadingBarAnimated"
@onready var percentage_label: Label = $Percentage

var scene_path: String = "res://Menu/Scenes/loading_screen.tscn"
var progress: Array[float] = [0.0]
var total_frames: int = 10  # Update based on your actual frame count
var loading_started: bool = false
var update: float = 0.0

func _ready() -> void:
	ResourceLoader.load_threaded_request(scene_path)
	loading_started = true

func _process(delta: float) -> void:
	if !loading_started:
		return

	var status = ResourceLoader.load_threaded_get_status(scene_path, progress)

	if progress[0] > update:
		update = progress[0]

	if update >= 1.0:
		get_tree().change_scene_to_packed(ResourceLoader.load_threaded_get(scene_path))

	# Update AnimatedSprite2D frame based on progress
	var frame_index := int(update * (total_frames - 1))
	frame_index = clamp(frame_index, 0, total_frames - 1)
	loading_bar.frame = frame_index

	# Update percentage label
	percentage_label.text = str(int(update * 100)) + " %"
