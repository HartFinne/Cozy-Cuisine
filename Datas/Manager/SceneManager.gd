extends Node

var gameplay_scene: Node = null
var market_scene: Node = null
var cook_book_scene: Node = null
var cooking_scene: Node = null
var touch_controls: CanvasLayer = null
var canvas_layer: CanvasLayer = null

func go_to_market():
	if gameplay_scene:
		gameplay_scene.visible = false
		touch_controls.visible = false
		canvas_layer.visible = false

	if not market_scene:
		market_scene = preload("res://Market (shops, items)/Scenes/market_scene.tscn").instantiate()
		gameplay_scene.get_node("UI/IntantiateScenes").add_child(market_scene)
	else:
		market_scene.visible = true  # Make the market scene visible if it's already loaded


func go_to_cook_book():
	if gameplay_scene:
		gameplay_scene.visible = false
		touch_controls.visible = false
		canvas_layer.visible = false

	if not cook_book_scene:
		cook_book_scene = preload("res://Cooking (mechanics and ui)/Scenes/CookBook/cook_book.tscn").instantiate()
		gameplay_scene.get_node("UI/IntantiateScenes").add_child(cook_book_scene)
	else:
		cook_book_scene.visible = true  # Make the market scene visible if it's already loaded
	
	
func go_to_cooking():
	if gameplay_scene:
		gameplay_scene.visible = false
		touch_controls.visible = false
		canvas_layer.visible = false
		
	if not cooking_scene:
		cooking_scene = preload("res://Cooking (mechanics and ui)/Scenes/cooking_scene.tscn").instantiate()
		gameplay_scene.get_node("UI/IntantiateScenes").add_child(cooking_scene)
	else:
		cooking_scene.visible = true  # Make it visible if it's already added to the scene


func return_to_game():
	if market_scene:
		market_scene.visible = false  # Hide the market scene instead of freeing it

		
	if cooking_scene:
		cooking_scene.visible = false  # Hide cooking scene when returning
		# to update the Popup of ingredient when buyingg a ingredients in market
		cooking_scene.get_node("IngredientPopup").update_popup_ui()
		
	if cook_book_scene:
		cook_book_scene.visible = false

	
	if gameplay_scene:
		gameplay_scene.visible = true
		gameplay_scene.set_process(true)
		gameplay_scene.set_physics_process(true)
		
		# just to update the moneycontienr in the testing scene
		canvas_layer.get_node("MoneyContainer").update_money_ui()
		touch_controls.visible = true
		canvas_layer.visible = true
		
		
