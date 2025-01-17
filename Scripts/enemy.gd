extends CharacterBody2D

enum Direction {
	RIGHT, 
	LEFT
}

@export var start_direction: Direction

var max_speed: int = 60
var direction: Vector2 = Vector2.RIGHT
var gravity: int = 500

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	direction = Vector2.RIGHT if start_direction == Direction.RIGHT else Vector2.LEFT

func _process(delta: float) -> void:
	velocity.x = (direction * max_speed).x
	
	velocity.y +=  gravity * delta
	
	move_and_slide()
	flip_enemy()
	
func flip_enemy():
	anim.flip_h = direction.x > 0


func _on_goal_detector_area_entered(_area: Area2D) -> void:
	direction *= -1


func _on_hit_box_area_area_entered(_area: Area2D) -> void:
	queue_free()
