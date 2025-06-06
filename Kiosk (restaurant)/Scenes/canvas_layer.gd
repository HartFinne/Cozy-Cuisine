extends CanvasLayer

@onready var tutorial_scene: Control = $TutorialScene
@onready var tutorial_button: TextureButton = $TutorialButton
@onready var touch_controls: CanvasLayer = $"../TouchControls"

func _ready():
	tutorial_scene.visible = false  # Start hidden
	tutorial_scene.process_mode = Node.PROCESS_MODE_ALWAYS  # Allow processing while game is paused
	tutorial_button.pressed.connect(_on_tutorial_button_pressed)
	tutorial_scene.connect("tutorial_finished", _on_tutorial_finished)

func _on_tutorial_button_pressed():
	print("✅ Tutorial button clicked")
	SoundEffects.play_transition()
	tutorial_scene.start_tutorial()
	tutorial_scene.visible = true
	tutorial_button.disabled = true
	get_tree().paused = true  # Pause the game
	if touch_controls:
		touch_controls.visible = false

func _on_tutorial_finished():
	tutorial_scene.visible = false
	tutorial_button.disabled = false
	touch_controls.visible = true
	get_tree().paused = false  # Resume the game
