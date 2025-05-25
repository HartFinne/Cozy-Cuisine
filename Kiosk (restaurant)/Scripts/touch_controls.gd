extends CanvasLayer

@onready var left: TouchScreenButton = $Left
@onready var right: TouchScreenButton = $Right
@onready var up: TouchScreenButton = $Up
@onready var down: TouchScreenButton = $Down

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	left.pressed.connect(on_button_pressed.bind(left))
	left.released.connect(on_button_released.bind(left))

	right.pressed.connect(on_button_pressed.bind(right))
	right.released.connect(on_button_released.bind(right))

	up.pressed.connect(on_button_pressed.bind(up))
	up.released.connect(on_button_released.bind(up))

	down.pressed.connect(on_button_pressed.bind(down))
	down.released.connect(on_button_released.bind(down))

# Function to lighten the button when pressed
func on_button_pressed(button: TouchScreenButton) -> void:
	button.modulate = Color(1.2, 1.2, 1.2, 1)  # Lighten the button

# Function to return to normal when released
func on_button_released(button: TouchScreenButton) -> void:
	button.modulate = Color(1, 1, 1, 1)  # Reset to normal

func _on_tutorial_button_pressed() -> void:
	visible = false

func _on_tutorial_finished() -> void:
	visible = true  
