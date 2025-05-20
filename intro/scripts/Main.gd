extends Node

var intro_scenes = {
	"intro1": preload("res://intro/scenes/intro1.tscn"),
	"intro2": preload("res://intro/scenes/intro2.tscn"),
	"intro3": preload("res://intro/scenes/intro3.tscn"),
	"intro4": preload("res://intro/scenes/intro4.tscn"),
	"intro5": preload("res://intro/scenes/intro5.tscn"),
	"intro6": preload("res://intro/scenes/kiosk.tscn")
}

@onready var fade_layer: ColorRect = $FadeLayer
@onready var intro_bgm: AudioStreamPlayer2D = $IntroBGM


var game_scene = load("res://Kiosk (restaurant)/Scenes/testing_scene.tscn")

var current_scene = null
var textbox_scene = preload("res://intro/scenes/textbox.tscn")
var textbox_instance = null

func _ready():
	intro_bgm.play()
	change_scene("intro1")
	
	
	textbox_instance = textbox_scene.instantiate()
	add_child(textbox_instance)
	
	
	textbox_instance.connect("change_scene_requested", Callable(self, "_on_change_scene_requested"))
	textbox_instance.connect("finished_displaying", Callable(self, "_on_textbox_finished"))

func change_scene(scene_name):
	
	if current_scene != null:
		current_scene.queue_free()
	
	
	if intro_scenes.has(scene_name):
		
		current_scene = intro_scenes[scene_name].instantiate()
		add_child(current_scene)
		
		move_child(current_scene, 0)
		print("Changed scene to: " + scene_name)
		
		if scene_name == "intro6":
			await textbox_instance.finished_displaying
			await get_tree().create_timer(2.0).timeout
			await fade_out_bgm() 
			await fade_out()
			get_tree().change_scene_to_packed(game_scene)
	else:
		print("Scene not found: " + scene_name)

func _on_change_scene_requested(scene_name):
	change_scene(scene_name)
	
func _on_textbox_finished():
	print("textbox is gone")
	
	
func fade_out(duration: float = 1.0):
	var tween = create_tween()
	tween.tween_property(fade_layer, "modulate:a", 1.0, duration)
	await tween.finished
	
func fade_in(duration: float = 1.0):
	var tween = create_tween()
	tween.tween_property(fade_layer, "modulate:a", 0.0, duration)
	await tween.finished
	
func fade_out_bgm(duration: float = 1.0):
	var tween = create_tween()
	tween.tween_property(intro_bgm, "volume_db", -80, duration)  # -80 dB = silent
	await tween.finished
	intro_bgm.stop()
