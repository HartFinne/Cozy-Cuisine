extends Control

var basket: Basket = Basket.load_basket()
var player_data: PlayerData = PlayerData.load_data()
var world_scene = load("res://Kiosk (restaurant)/Scenes/testing_scene.tscn")
var intro_scene = load("res://intro/scenes/Main.tscn")
@onready var popup_panel: PopupPanel = $Panel/PopupPanel
@onready var admob: Admob = $Admob

var is_initialized: bool = false

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
	
	


func _on_play_pressed() -> void:
	player_data.is_intro_watched
	
	if world_scene and player_data.is_intro_watched:
		get_tree().change_scene_to_packed(world_scene)
		player_data.save()
		basket.save_basket()
	elif not player_data.is_intro_watched:
		get_tree().change_scene_to_packed(intro_scene)
		player_data.is_intro_watched = true
		player_data.save()
	else:
		print("Failed to load")
	print("Start Button")
	pass
	
func _on_tutorial_pressed() -> void:
	print("Tutorialssss")
	get_tree().paused = true
	popup_panel.show()
	
	
func _on_quit_pressed() -> void:
	get_tree().quit()


func _on_setting_button_pressed() -> void:
	get_tree().paused = true
	popup_panel.show()
