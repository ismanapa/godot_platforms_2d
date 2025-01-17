extends Node

enum Levels { Level_01, Level_02 }

var next_level: Levels

func _ready() -> void:
	EventBus.level_changed.connect(_on_next_level_changed)
	
func getNextLevelScene():
	return load("res://Scenes/Levels/"+Levels.keys()[next_level]+".tscn")
	
func _on_next_level_changed(level: LevelManager.Levels) -> void:
	print("level changed")
	next_level = level
