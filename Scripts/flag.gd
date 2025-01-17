extends Node2D

@export var next_level: LevelManager.Levels

var level_complete = load("res://Scenes/UI/level_complete.tscn")

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("Player"):
		EventBus.level_changed.emit(next_level)
		get_tree().change_scene_to_packed(level_complete)
