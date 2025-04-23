extends Control
@onready var admob: Admob = $Admob
var is_initialized : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	admob.initialize()
	admob.initialization_completed.connect(_on_admob_initialization_completed)


func _on_admob_initialization_completed(status_data: InitializationStatus) -> void:
	is_initialized = true
	load_and_show_banner()
	pass # Replace with function body.
	
func load_and_show_banner():
	if is_initialized:
		admob.load_banner_ad()
		await admob.banner_ad_loaded
		admob.show_banner_ad()
