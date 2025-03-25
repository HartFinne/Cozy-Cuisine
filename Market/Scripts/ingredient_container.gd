extends PanelContainer

@onready var ingredient_label: Label = %IngredientLabel

func set_ingredient_name(name: String):
	ingredient_label = %IngredientLabel
	print(name)
	ingredient_label.text = name
