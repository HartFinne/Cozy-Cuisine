extends TextureButton

@onready var ingredient_popup: PopupPanel = %IngredientPopup

var ingredient_name = ""


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	connect("pressed", _on_ingredient_clicked)
	# print(ingredient_popup)
	
	
func _on_ingredient_clicked():
	if ingredient_popup:
		ingredient_popup.show_popup(self)  # Pass this ingredient slot
		# print(self)
		
