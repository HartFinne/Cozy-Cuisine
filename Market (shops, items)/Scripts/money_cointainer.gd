extends PanelContainer

@onready var coin_label: Label = %CoinLabel
@onready var gem_label: Label = %GemLabel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var basket_gd = get_parent().get_node("TabContainer/Basket")
	basket_gd.purchase_completed.connect(_on_purchase_completed)
	
	MoneyManager.load_player_data()  # Load budget from JSON
	update_money_ui();
	
func update_money_ui():
	# Update UI labels if they display currency
	coin_label.text = str(int(MoneyManager.budget))
	
func _on_purchase_completed(total_cost: float) -> void:
	# Deduct total cost from budget
	MoneyManager.deduct_money(total_cost)  # Deduct money from budget
	update_money_ui()  # Refresh UI after deduction
	print("Budget updated:", MoneyManager.budget)

func _on_more_button_pressed() -> void:
	print("working")
	pass # Replace with function body.
