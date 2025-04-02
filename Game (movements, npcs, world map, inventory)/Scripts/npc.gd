extends CharacterBody2D

var player_data: PlayerData = PlayerData.load_data()
@onready var main_character: CharacterBody2D = $"../mainCharacter"
@onready var dialogue: Control = $Dialogue
@export var customer: Customer

var player_in_area: bool = false
var x_button: TouchScreenButton  # Declare variable
var take_button: Button


func _ready():
	# ✅ Ensure UI is fully loaded before accessing XButton
	var ui = get_tree().get_root().find_child("UI", true, false)

	x_button = ui.find_child("XButton", true, false)
	take_button = ui.find_child("TakeButton", true, false)
	
	if take_button:
		take_button.connect("pressed", Callable(self, "_on_take_button_pressed"))
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:

	if player_in_area and Input.is_action_just_pressed("accept"):
		dialogue.visible = true
		%StartConversation.visible = false
		x_button.visible = false
		take_button.visible = true
		show_customer_order()
		
func show_customer_order():
	if customer and customer.order:
		var name_text = customer.name + "'s Order:\n"
		var order_text: String

		for item_name in customer.order.keys():
			var menu_item = MenuManagers.menu_items.get(item_name)  # ✅ Fetch from global menu

			if menu_item:
				order_text += str(customer.order[item_name]) + " " + menu_item.label
			else:
				order_text += item_name

		print("Debug - Order Text:", order_text)
		dialogue.set_dialog_text(name_text, order_text)
	else:
		print("⚠️ Order data is missing or empty!")


func _on_take_button_pressed():
	if customer and customer.order:
		print("working", customer.order)
		player_data.order = customer.order
		print(player_data.order)
		player_data.save()
		
		if take_button:
			take_button.visible = false
	else:
		print("NO order to take")


func _on_area_2d_body_entered(body: Node2D) -> void:
	print("Body entered:", body.name)  # Debugging: Print
	if body.is_in_group("player"): # Ensure it's the player
		player_in_area = true
		print("Player entered NPC area")
		%StartConversation.visible = true
		
func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_in_area = false
		print("Player left NPC area")
		dialogue.visible = false
		%StartConversation.visible = false
		x_button.visible = true
