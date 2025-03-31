extends CharacterBody2D

@export var move_speed: float = 100

@onready var animated_sprite = $AnimatedSprite2D
var last_direction = Vector2.DOWN  

func _ready():
	add_to_group("player")  

func _physics_process(delta) -> void:
	handle_manual_input()

func handle_manual_input():
	var input_direction = Vector2(
		Input.get_action_strength("right") - Input.get_action_strength("left"),
		Input.get_action_strength("down") - Input.get_action_strength("up")
	).normalized()

	velocity = input_direction * move_speed
	move_and_slide()

	if input_direction != Vector2.ZERO:
		_play_walk_animation(input_direction)
		last_direction = input_direction
	else:
		_play_idle_animation()

func _play_walk_animation(direction: Vector2):
	if abs(direction.x) > abs(direction.y):  
		animated_sprite.play("walk_right" if direction.x > 0 else "walk_left")
	else:
		animated_sprite.play("walk_front" if direction.y > 0 else "walk_back")

func _play_idle_animation():
	if abs(last_direction.x) > abs(last_direction.y):  
		animated_sprite.play("idle_right" if last_direction.x > 0 else "idle_left")
	else:
		animated_sprite.play("idle_front" if last_direction.y > 0 else "idle_back")
