extends CharacterBody2D

class_name Player

signal died

enum State { NORMAL, DASHING }
var current_state: State = State.NORMAL

var gravity : int = 1000

var max_speed : int = 100
var max_jump_speed : int = 360
var horizontal_acceleration: int = 1200

var max_dash_speed : int = 400
var min_dash_speed : int = 100
var is_state_new : bool = true

var jump_count: int = 0
var is_jumping : bool = false

var camera: PlayerCamera = null

@onready var anim = $AnimatedSprite2D
@onready var dash_area = $DashArea/CollisionShape2D
@onready var foot_step_audio = $FootStepAudioPlayer

func _ready() -> void:
	camera = get_tree().get_first_node_in_group("Camera")

func _process(delta: float) -> void:
	match current_state:
		State.NORMAL:
			player_movement(delta)
		State.DASHING:
			dash(delta)
	
	is_state_new = false
	
func dash(delta: float):
	if is_state_new:
		var movement = get_input_actions()
		
		dash_area.disabled = false
		anim.play("jump")
		
		var dash_directions = 1
		
		if movement.x != 0:
			dash_directions = sign(movement.x)
		else:
			dash_directions = 1 if anim.flip_h else -1
		
		
		velocity = Vector2(max_dash_speed * dash_directions, 0)
		
	move_and_slide()

	velocity.x = lerp(0.0, velocity.x, pow(2, -5 * delta))
	
	if abs(velocity.x) < min_dash_speed:
		call_deferred("change_state", State.NORMAL)
	
func change_state(new_state: State):
	current_state = new_state
	is_state_new = true

func player_movement(delta:float): 
	var input_action = get_input_actions()
	
	if is_on_floor():
		jump_count = 0
	
	if has_to_jump() and jump_count < 2:
		jump_count += 1
		velocity.y = -max_jump_speed
	
	#velocity.x = move_vector.x * max_speed
	velocity.x += input_action.x * horizontal_acceleration * delta;
	
	if input_action.x == 0:
		velocity.x = lerp(velocity.x, 0.0, 0.1)
		
	velocity.x = clamp(velocity.x, -max_speed, max_speed )
	
	if Input.is_action_just_pressed("dash"):
		call_deferred("change_state", State.DASHING)
	
	if is_state_new:
		dash_area.disabled = true
		
	velocity.y += gravity * delta
	
	move_and_slide()
	player_animations()

func get_input_actions(): 
	var move_vector = Vector2.ZERO
	
	move_vector.x = Input.get_action_strength("move_right")- Input.get_action_strength("move_left")
	move_vector.y = Input.get_action_strength("jump") * -1
	
	return move_vector
	
func has_to_jump():
	return Input.is_action_just_pressed("jump")

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


func _on_animated_sprite_2d_frame_changed() -> void:
	if $AnimatedSprite2D.animation == "run":
		foot_step_audio.play()
