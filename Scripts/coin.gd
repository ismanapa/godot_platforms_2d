extends Node2D

@onready var anim = $AnimationPlayer
@onready var collision = $Area2D/CollisionShape2D

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("Player"):
		EventBus.coin_picked_up.emit()
		anim.play("Pickup")
		call_deferred("disable_pickup")
	
func disable_pickup():
	collision.disabled = false
