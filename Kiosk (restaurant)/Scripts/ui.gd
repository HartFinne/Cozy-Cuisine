extends Control

@onready var inventory: HBoxContainer = $CanvasLayer/Inventory
@onready var admob: Admob = $Admob

var is_initialized : bool = false
signal banner_ready


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
		adjust_ui_for_banner()
		emit_signal("banner_ready")
		
		
func adjust_ui_for_banner():
	var banner_height = 90
	var inventory = $CanvasLayer/Inventory
	
	inventory.position.y -= banner_height
