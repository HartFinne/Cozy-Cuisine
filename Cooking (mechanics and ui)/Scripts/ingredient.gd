extends TextureButton

@onready var ingredient_popup: PopupPanel = %IngredientPopup

var ingredient_name = ""

var player_data: PlayerData = PlayerData.load_data()
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	connect("pressed", _on_ingredient_clicked)
	player_data.print_hello_workd()
	# print(ingredient_popup)
	
	
func _on_ingredient_clicked():
	if ingredient_popup:
		ingredient_popup.show_popup(self)  # Pass this ingredient slot
		# print(self)
		
