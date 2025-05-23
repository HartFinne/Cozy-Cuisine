extends VBoxContainer
# popup panel
@onready var popup_panel: PopupPanel = $PopupPanel
@onready var button: Button = $PopupPanel/VBoxContainer/Button
@onready var tab_container: TabContainer = $".."


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_tab_container_tab_changed(tab: int) -> void:
	if tab == 3:
		print("working")
		$PopupPanel.popup_centered()
		pass


func _on_button_pressed() -> void:
	tab_container.current_tab = 0
	$PopupPanel.hide()
	pass # Replace with function body.


func _on_popup_panel_popup_hide() -> void:
	tab_container.current_tab = 0
	pass # Replace with function body.
