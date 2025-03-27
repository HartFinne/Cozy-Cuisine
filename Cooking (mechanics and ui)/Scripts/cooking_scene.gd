extends Control

@onready var ingredients: GridContainer = %Ingredients
@onready var ingredient_popup: PopupPanel = %IngredientPopup


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


func _on_cook_button_pressed() -> void:
	print("working")
