extends Control


@onready var admob: Admob = $CanvasLayer/Admob

@onready var inventory: HBoxContainer = $CanvasLayer/InventoryWrapper/Inventory
@onready var inventory_wrapper: Control = $CanvasLayer/InventoryWrapper




var is_initialized: bool = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	admob.initialize()
	admob.initialization_completed.connect(_on_admob_initialization_completed)




func _on_admob_initialization_completed(status_data: InitializationStatus) -> void:
	is_initialized = true
	load_and_show_banner()
	
func load_and_show_banner():
	if is_initialized:
		admob.load_banner_ad()
		await admob.banner_ad_loaded
		admob.show_banner_ad()
		adjust_ui_for_banner()


func adjust_ui_for_banner():
	var banner_height_px = get_banner_height_px(admob.banner_size)

	inventory_wrapper.position.y = -banner_height_px


func get_banner_height_px(ad_size: LoadAdRequest.AdSize) -> int:
	var dp := 50 # Default fallback

	match ad_size:
		LoadAdRequest.AdSize.BANNER:
			dp = 30
		LoadAdRequest.AdSize.LARGE_BANNER:
			dp = 100
		LoadAdRequest.AdSize.MEDIUM_RECTANGLE:
			dp = 250
		LoadAdRequest.AdSize.FULL_BANNER:
			dp = 60
		LoadAdRequest.AdSize.LEADERBOARD:
			dp = 90

	var dpi_scale = DisplayServer.screen_get_dpi() / 160.0
	return int(dp * dpi_scale)
	
	
