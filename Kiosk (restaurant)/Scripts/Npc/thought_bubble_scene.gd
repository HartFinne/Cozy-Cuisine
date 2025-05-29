extends Control
@onready var grid_container: GridContainer = $NinePatchRect/GridContainer

var panel_container_scene = preload("res://Kiosk (restaurant)/Scenes/Npc/panel_container.tscn")

func _ready() -> void:
	pass
	
func populate_panel_container(order_data: Array):
	# Clear existing UI
	for child in grid_container.get_children():
		child.queue_free()

	# Dynamically set number of columns
	grid_container.columns = min(order_data.size(), 2)

	# Populate UI with order data
	for item in order_data:
		var container_instance = panel_container_scene.instantiate()

		print(container_instance.has_node("Label"), "label")
		if container_instance.has_node("MarginContainer/Label"):
			var label = container_instance.get_node("MarginContainer/Label")
			label.text = "%d" % [item["need"]]

		if container_instance.has_node("TextureRect"):
			var tex_rect = container_instance.get_node("TextureRect")
			tex_rect.texture = item["image"]

		grid_container.add_child(container_instance)
