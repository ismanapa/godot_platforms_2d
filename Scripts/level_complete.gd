extends CanvasLayer

var level = load("res://Scenes/Levels/level_02.tscn")

func _on_button_pressed() -> void:		
	get_tree().change_scene_to_packed(LevelManager.getNextLevelScene())
