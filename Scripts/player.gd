extends CharacterBody2D

class_name Player

signal died

var gravity : int = 1000
var max_speed : int = 100
var max_jump_speed : int = 360
var horizontal_acceleration: int = 1200
var camera: PlayerCamera = null

@onready var anim = $AnimatedSprite2D

func _ready() -> void:
	camera = get_tree().get_first_node_in_group("Camera")

func _process(delta: float) -> void:
	var input_action = get_input_actions()
	
	if input_action.y < 0 and is_on_floor():
		velocity.y = input_action.y * max_jump_speed
	
	#velocity.x = move_vector.x * max_speed
	velocity.x += input_action.x * horizontal_acceleration * delta;
	
	if input_action.x == 0:
		velocity.x = lerp(velocity.x, 0.0, 0.1)
		
	velocity.x = clamp(velocity.x, -max_speed, max_speed )
	
	velocity.y += gravity * delta
	
	move_and_slide()
	player_animations()


func get_input_actions(): 
	var move_vector = Vector2.ZERO
	
	move_vector.x = Input.get_action_strength("move_right")- Input.get_action_strength("move_left")
	move_vector.y = Input.get_action_strength("jump") * -1
	
	return move_vector

func player_animations(): 
	var movement = get_input_actions()
	
	flip_player(movement)
	
	if !is_on_floor(): 
		anim.play("jump")
		return
		
	if movement.x != 0:
		anim.play("run")
		return
		
	anim.play("idle")

func flip_player(move):
	if move.x != 0:
		anim.flip_h = move.x > 0

func _on_trap_area_area_entered(area: Area2D) -> void:
	if area.is_in_group("Danger"):
		died.emit()
		camera.is_player = false
