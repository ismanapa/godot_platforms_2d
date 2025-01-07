extends Node

@export var player: Player

var player_scene: Resource = preload("res://Scenes/Player.tscn")

var spawn_position = Vector2.ZERO
var current_player_node: Player = null

func _ready() -> void:
	spawn_position = player.global_position
	register_player(player)
	
func register_player(regist_player: Player):
	current_player_node = regist_player
	current_player_node.died.connect(on_player_died)
	
func create_player():
	var player_instance: Player = player_scene.instantiate()
	player_instance.global_position = spawn_position
	add_child(player_instance)
	register_player(player_instance)

func on_player_died():
	current_player_node.queue_free()
	call_deferred("create_player")
