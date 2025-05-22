extends Control

var tutorial_images = [
	preload("res://Tutorial/Assets/2.png"),
	preload("res://Tutorial/Assets/3.png"),
	preload("res://Tutorial/Assets/4.png"),
	preload("res://Tutorial/Assets/5.png"),
	preload("res://Tutorial/Assets/6.png"),
	preload("res://Tutorial/Assets/7.png"),
	preload("res://Tutorial/Assets/8.png"),
	preload("res://Tutorial/Assets/9.png"),
	preload("res://Tutorial/Assets/10.png"),
	preload("res://Tutorial/Assets/11.png"),
]

var current_index = 0

signal tutorial_finished

@onready var texture_rect: TextureRect = $TextureRect

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	show_tutorial_image()
	pass # Replace with function body.

func _input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		show_next_image()

func show_tutorial_image():
	texture_rect.texture = tutorial_images[current_index]

func show_next_image():
	current_index += 1
	if current_index < tutorial_images.size():
		show_tutorial_image()
	else:
		emit_signal("tutorial_finished")
		hide()  # Or queue_free(), or signal tutorial end


func _on_tutorial_button_pressed() -> void:
	pass # Replace with function body.
