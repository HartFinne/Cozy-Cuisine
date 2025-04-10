extends HBoxContainer


@onready var dish_back_button: Button = $DishBackButton
@onready var dish_vbox: VBoxContainer = $PanelContainer/ScrollContainer/DishVbox
@onready var dish_button: Button = $"../DishButton"
@onready var orders_button: Button = %OrdersButton



var dish_container_scene = preload("res://Cooking (mechanics and ui)/Scenes/dish_container.tscn")
var dishes = MenuManager.recipes


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print(self)
	if dish_button:
		print(dish_button, "ture")
		dish_button.pressed.connect(_on_dish_button_pressed)
	populate_dish_container()
	pass # Replace with function body.

func populate_dish_container():
	
	for child in dish_vbox.get_children():
		child.queue_free()
	
	for dish_name in dishes:
		var dish_instance = dish_container_scene.instantiate()
		print(dish_name, "flkjasdlkfjkfdasjfkdsfdsl;kfjdsklfsdajflkd")
		
		if dish_instance.has_method("set_dish_data"):
			dish_instance.set_dish_data(dish_name)
			
		dish_vbox.add_child(dish_instance)




func _on_dish_button_pressed() -> void:
	print("working")
	self.visible = true
	orders_button.visible = false
	dish_button.visible = false
	pass # Replace with function body.


func _on_dish_back_button_pressed() -> void:
	self.visible = false
	orders_button.visible = true
	dish_button.visible = true
	pass # Replace with function body.
