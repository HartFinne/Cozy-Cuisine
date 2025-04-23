extends Node

var world_scene = load("res://Kiosk (restaurant)/Scenes/testing_scene.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("workds")
	if world_scene:
		world_scene.get_node($UI/Admob)
		
		


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
