extends Control

@onready var texture_progress_bar: TextureProgressBar = $TextureProgressBar
@onready var percentage: Label = $Percentage
@onready var change_scene_timer: Timer = $ChangeSceneTimer

var scene_path : String
var progress : Array

var update : float = 0.0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	scene_path = "res://Menu/Scenes/main_screen.tscn"
	ResourceLoader.load_threaded_request(scene_path)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	ResourceLoader.load_threaded_get_status(scene_path, progress)
	
	if progress[0] > update:
		update = progress[0]
		
	if texture_progress_bar.value >= 1.0:
		if update >= 1.0:
			get_tree().change_scene_to_packed(
				ResourceLoader.load_threaded_get(scene_path)
			)
	
	if texture_progress_bar.value < update:
		texture_progress_bar.value = lerp(texture_progress_bar.value, update, delta)
	texture_progress_bar.value += delta * 0.2 * (0.5 if update >= 1.0 else clamp(0.9 - texture_progress_bar.value, 0.0, 1.0))
		
		
	percentage.text = str(int(texture_progress_bar.value * 100.0)) + " %"
	
