extends Node

var intro_scenes = {
	"intro1": preload("res://intro/scenes/intro1.tscn"),
	"intro2": preload("res://intro/scenes/intro2.tscn"),
	"intro3": preload("res://intro/scenes/intro3.tscn"),
	"intro4": preload("res://intro/scenes/intro4.tscn"),
	"intro5": preload("res://intro/scenes/intro5.tscn"),
	"intro6": preload("res://intro/scenes/kiosk.tscn")
}

var current_scene = null
var textbox_scene = preload("res://intro/scenes/textbox.tscn")
var textbox_instance = null

func _ready():

	change_scene("intro1")
	
	
	textbox_instance = textbox_scene.instantiate()
	add_child(textbox_instance)
	
	
	textbox_instance.connect("change_scene_requested", Callable(self, "_on_change_scene_requested"))

func change_scene(scene_name):
	
	if current_scene != null:
		current_scene.queue_free()
	
	
	if intro_scenes.has(scene_name):
		
		current_scene = intro_scenes[scene_name].instantiate()
		add_child(current_scene)
		
		move_child(current_scene, 0)
		print("Changed scene to: " + scene_name)
	else:
		print("Scene not found: " + scene_name)

func _on_change_scene_requested(scene_name):
	change_scene(scene_name)
