extends PanelContainer

@onready var coin_label: Label = %CoinLabel
@onready var gem_label: Label = %GemLabel
@onready var basket: TabBar = %Basket

var player_data: PlayerData = PlayerData.load_data()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if basket != null and basket.has_signal("purchase_completed"):
		basket.purchase_completed.connect(_on_purchase_completed)
	update_money_ui();
	
func update_money_ui():
	# Update UI labels if they display currency
	coin_label.text = str(int(player_data.budget))
	print(player_data.budget, " fslfkas;ksl;kf;alskf;l")
	
func _on_purchase_completed(total_cost: float) -> void:
	# Deduct total cost from budget
	print(total_cost, "onpurchased")
	# minus the budget
	player_data.budget -= total_cost
	player_data.save()
	update_money_ui()  # Refresh UI after deduction
	print("Budget updated:", player_data.budget)

func _on_more_button_pressed() -> void:
	print(get_tree())
	print("working")
	pass # Replace with function body.
