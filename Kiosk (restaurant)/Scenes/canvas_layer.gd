extends CanvasLayer

@onready var tutorial_scene: Control = $TutorialScene
@onready var tutorial_button: TextureButton = $TutorialButton
@onready var touch_controls: CanvasLayer = $TouchControls

func _ready():
	tutorial_scene.visible = false  # Start hidden
	tutorial_button.pressed.connect(_on_tutorial_button_pressed)
	tutorial_scene.connect("tutorial_finished", _on_tutorial_finished)

func _on_tutorial_button_pressed():
	print("✅ Tutorial button clicked")
	tutorial_scene.start_tutorial()
	tutorial_scene.visible = true
	tutorial_button.disabled = true
	if touch_controls:
		touch_controls.visible = false

func _on_tutorial_finished():
	tutorial_button.disabled = false  # Re-enable after tutorial ends
