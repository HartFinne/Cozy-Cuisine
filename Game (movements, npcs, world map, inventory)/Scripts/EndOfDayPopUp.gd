extends Control

@onready var budget_label = $EndOfDayPanel/VBoxContainer/CurrentLabel
@onready var revenue_label = $EndOfDayPanel/VBoxContainer/RevenueLabel
@onready var expenses_label = $EndOfDayPanel/VBoxContainer/ExpenseLabel
@onready var profit_label = $EndOfDayPanel/VBoxContainer/ProfitLabel

func _ready():
	print("✅ Labels Ready:", budget_label, revenue_label, expenses_label, profit_label)

func update_popup():
	print("Labels:", budget_label, revenue_label, expenses_label, profit_label)
	
	if not budget_label:
		print("❌ ERROR: budget_label is NULL")
		return  # Prevent crash
		
	if not DailyScript.player_data or typeof(DailyScript.player_data) != TYPE_DICTIONARY:
		print("❌ ERROR: DailyScript.player_data is invalid or empty!")
		return

	# Assign values safely
	var budget = DailyScript.player_data.get("budget", 0)
	var revenue = DailyScript.player_data.get("revenue", 0)
	var expenses = DailyScript.player_data.get("expenses", 0)
	var profit = DailyScript.player_data.get("profit", 0)

	print("✅ Budget:", budget, "Revenue:", revenue, "Expenses:", expenses, "Profit:", profit)  # Debug values

	# Update labels
	budget_label.text = "Current Budget: $" + str(budget)
	revenue_label.text = "Revenue: $" + str(revenue)
	expenses_label.text = "Expenses: $" + str(expenses)
	profit_label.text = "Profit: $" + str(profit)
