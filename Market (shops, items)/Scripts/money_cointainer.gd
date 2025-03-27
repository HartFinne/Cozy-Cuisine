extends PanelContainer

@onready var coin_label: Label = %CoinLabel
@onready var gem_label: Label = %GemLabel
@onready var basket: TabBar = %Basket

var player_data: PlayerData = PlayerData.load_data()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	basket.purchase_completed.connect(_on_purchase_completed)
	update_money_ui();
	
func update_money_ui():
	# Update UI labels if they display currency
	coin_label.text = str(int(player_data.budget))
	
func _on_purchase_completed(total_cost: float) -> void:
	# Deduct total cost from budget
	print(total_cost, "onpurchased")
	# minus the budget
	player_data.budget -= total_cost
	update_money_ui()  # Refresh UI after deduction
	print("Budget updated:", player_data.budget)

func _on_more_button_pressed() -> void:
	print("working")
	pass # Replace with function body.
