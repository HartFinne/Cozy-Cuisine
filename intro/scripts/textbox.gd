extends CanvasLayer

const CHAR_READ_RATE = 0.05

@onready var textbox_container = $TextboxContainer
@onready var start_symbol = $TextboxContainer/MarginContainer/HBoxContainer/Start
@onready var end_symbol = $TextboxContainer/MarginContainer/HBoxContainer/End
@onready var label = $TextboxContainer/MarginContainer/HBoxContainer/Label

enum State {
	READY, 
	READING, 
	FINISHED
}

var current_state = State.READY
var text_queue = []
var scene_changes = {}  
var current_scene_index = 1  
var tween

var tapped := false


signal change_scene_requested(scene_name)
signal finished_displaying

func _ready():
	print("Starting state: State.READY")
	hide_textbox()
	setup_scene_transitions()
	
	#1st scene
	queue_text("Boss: I'm really sorry, but… we have to downsize the company. Your position is being cut.")
	queue_text("Elena: W-What? But I've been working so hard…")
	queue_text("Boss: I know. It's not about your performance. It's just… business.")
	
	#2nd scene
	queue_text("Elena: Just like that… it's over.", "intro2")
	
	#3rd scene
	queue_text("Elena: Where am I supposed to get money now?", "intro3")
	
	#4th scene
	queue_text("Elena: Wait… I remember…!", "intro4")
	
	#5th scene
	queue_text("Elena: My grandmother used to run a small food stand. She taught me that cooking wasn't just about making food.", "intro5")
	queue_text("Elena: She taught me that cooking wasn't just about making food.")
	queue_text("Elena: it was about sharing warmth, care, and happiness with others.")
	#6th scene
	queue_text("Elena: That's it! I'll start my own food business!", "intro6")
	queue_text("Elena: Alright… time to cook up a new beginning!")

func setup_scene_transitions():
	pass

func _process(delta):
	match current_state:
		State.READY:
			if !text_queue.is_empty():
				display_text()
		State.READING:
			if was_screen_tapped():
				label.visible_ratio = 1.0
				tween.kill()
				end_symbol.text = "v"
				change_state(State.FINISHED)
		State.FINISHED:
			if was_screen_tapped():
				change_state(State.READY)
				hide_textbox()
				
				# Emit signal if nothing left to say
				if text_queue.is_empty():
					emit_signal("finished_displaying")
					
func _input(event):
	if event is InputEventScreenTouch and event.pressed:
		tapped = true

func was_screen_tapped() -> bool:
	if tapped:
		tapped = false
		return true
	return false


func queue_text(next_text, scene_to_change_to = ""):
	
	text_queue.push_back({"text": next_text, "scene": scene_to_change_to})

func hide_textbox():
	start_symbol.text = ""
	end_symbol.text = ""
	label.text = ""
	textbox_container.hide()

func show_textbox():
	start_symbol.text = "*"
	textbox_container.show()

func display_text():
	var next_item = text_queue.pop_front()
	var next_text = next_item["text"]
	var next_scene = next_item["scene"]
	
	
	if next_scene != "":
		emit_signal("change_scene_requested", next_scene)
	
	show_textbox()
	change_state(State.READING)

	if tween and tween.is_valid():
		tween.kill()

	label.text = next_text
	label.visible_ratio = 0.0  
	tween = create_tween()
	tween.set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(label, "visible_ratio", 1.0, len(next_text) * CHAR_READ_RATE)

	await tween.finished
	end_symbol.text = "v"
	change_state(State.FINISHED)
	
func change_state(next_state):
	current_state = next_state
	match current_state:
		State.READY:
			print("Changing state to: State.READY")
		State.READING:
			print("Changing state to: State.READING")
		State.FINISHED:
			print("Changing state to: State.FINISHED")
