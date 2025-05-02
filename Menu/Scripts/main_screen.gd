extends Control

var basket: Basket = Basket.load_basket()
var player_data: PlayerData = PlayerData.load_data()
var world_scene = load("res://Kiosk (restaurant)/Scenes/testing_scene.tscn")
var intro_scene = preload("res://intro/scenes/Main.tscn")
const settings = preload("res://Menu/Scenes/settings.tscn")
@onready var popup_panel: PopupPanel = $Panel/PopupPanel
@onready var admob: Admob = $Admob
var is_initialized: bool = false
@onready var resetconfirmdialog: ConfirmationDialog = %resetconfirmdialog
@onready var reset: Button = $Panel/VBoxContainer/reset

func _on_play_pressed() -> void:
	ClickSound.play_click()
	print("wiwer")
	player_data.is_intro_watched
	
	if world_scene and player_data.is_intro_watched:
		get_tree().change_scene_to_packed(world_scene)
		player_data.save()
		basket.save_basket()
		player_data.order = {}
	elif not player_data.is_intro_watched:
		get_tree().change_scene_to_packed(intro_scene)
		player_data.is_intro_watched = true
		player_data.save()
		player_data.order = {}
	else:
		print("Failed to load")
	print("Start Button")
	
	reset.visible = false
	
	
	
func _on_tutorial_pressed() -> void:
	print("Tutorialssss")
	get_tree().paused = true
	popup_panel.show()
	

func _on_reset_pressed() -> void:
	resetconfirmdialog.popup_centered()
	pass # Replace with function body.
	

func _on_resetconfirmdialog_confirmed() -> void:
	player_data.budget = 1000.0
	player_data.days = 1
	player_data.is_intro_watched = false
	player_data.is_tutorial_watched = false
	player_data.expenses = 0.0
	player_data.profit = 0.0
	player_data.revenue = 0.0
	player_data.total_profit = 0.0
	player_data.inventory = {}
	player_data.selected_ingredients = {}  # Store selected ingredients
	player_data.dishes = {}
	player_data.dish_order = []
	player_data.order = {}
	player_data.player_position = Vector2(136.0, 128.0)  # Example starting position

	player_data.goal_profit_per_day = 100.0  # You can change the number as needed

	player_data.music_volume = 1.0
	player_data.sfx_volume = 1.0
	
	reset.visible = false  # ✅ Hide reset button again after resetting

	
	
func _on_quit_pressed() -> void:
	ClickSound.play_click()
	get_tree().quit()


func _on_setting_button_pressed() -> void:
	ClickSound.play_click()
	var settings_instance = settings.instantiate()
	add_child(settings_instance)
	
	
func _ready() -> void:
	if player_data.is_intro_watched:
		reset.visible = true
	else:
		reset.visible = false
	
	
	#When game starts, apply the saved volumes
	var music_bus_index = AudioServer.get_bus_index("Music")
	var sfx_bus_index = AudioServer.get_bus_index("SFX")

	AudioServer.set_bus_volume_db(music_bus_index, linear_to_db(player_data.music_volume))
	AudioServer.set_bus_volume_db(sfx_bus_index, linear_to_db(player_data.sfx_volume))

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
