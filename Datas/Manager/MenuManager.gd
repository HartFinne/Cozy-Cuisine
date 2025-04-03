extends Node
class_name MenuManager


var menu_items: Dictionary = {}  # Key: Name, Value: MenuItem resource


func _ready():
	# ✅ Load all menu items ONCE and share them across NPCs
	menu_items["BurgerSteak"] = preload("res://Datas/Resources/MenuItems/BurgerSteak.tres")
	menu_items["PeperoniPizza"] = preload("res://Datas/Resources/MenuItems/PeperoniPizza.tres")
