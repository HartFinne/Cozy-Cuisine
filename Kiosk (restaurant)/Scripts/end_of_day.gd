extends PopupPanel
@onready var profit_total: Label = %ProfitTotal
@onready var revenue_total: Label = %RevenueTotal
@onready var expenses_total: Label = %ExpensesTotal

var player_data: PlayerData = PlayerData.load_data()

var testing_scene: Node2D

func _ready() -> void:
	set_exclusive(true)  # This makes the popup modal
	connect("visibility_changed", _on_visibility_changed)

func _on_visibility_changed():
	pass

func set_testing_script(testing_script: Node2D) -> void:
	testing_scene = testing_script

func end_day_update_ui():
	profit_total.text = str(int(player_data.profit))
	revenue_total.text = str(int(player_data.revenue))
	expenses_total.text = str(int(player_data.expenses))
	
	
func _on_continue_pressed() -> void:
	get_tree().paused = false
	if testing_scene:
		testing_scene.is_day_ended = false
		testing_scene.start_day_button.visible = false
		testing_scene.goal_container.visible = true
		# 🧼 Force all remaining customers to leave
		for path in testing_scene.paths:
			if path.get_child_count() > 0:
				testing_scene.resume_customer_movement(path)
	self.hide()
	testing_scene.start_and_goal_update_ui()


func _on_quit_pressed() -> void:
	get_tree().paused = false
	if testing_scene:
		testing_scene.is_day_ended = true
		testing_scene.start_day_button.visible = true
		testing_scene.goal_container.visible = false
		testing_scene.revenue = 0
		testing_scene.profit = 0
		
		# 🧼 Force all remaining customers to leave
		for path in testing_scene.paths:
			if path.get_child_count() > 0:
				testing_scene.resume_customer_movement(path)
	self.hide()
	testing_scene.start_and_goal_update_ui()
