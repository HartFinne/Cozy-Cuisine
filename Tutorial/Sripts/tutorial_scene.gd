extends Control
signal tutorial_finished

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

var current_index := 0
@onready var texture_rect: TextureRect = $TextureRect

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS  # ✅ Allow processing even when the game is paused

func start_tutorial() -> void:
	current_index = 0
	_show_current_image()
	visible = true
	set_process_input(true)
	get_tree().paused = true  # ⏸ Pause the game

func _show_current_image() -> void:
	texture_rect.texture = tutorial_images[current_index]

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		_next()

func _next() -> void:
	current_index += 1
	if current_index < tutorial_images.size():
		_show_current_image()
	else:
		visible = false
		set_process_input(false)
		get_tree().paused = false  # ▶ Unpause the game
		emit_signal("tutorial_finished")
