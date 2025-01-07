extends Camera2D

class_name PlayerCamera

var players
var target_position = Vector2.ZERO
var is_player: bool

@export var background : Color

func _ready() -> void:
	is_player = true
	players = get_tree().get_nodes_in_group("Player")
	
	RenderingServer.set_default_clear_color(background)

func _process(_delta: float) -> void:
	if is_player != true:	
		players = get_tree().get_nodes_in_group("Player")
		is_player = true

	follow_player()

	global_position = lerp(target_position, global_position, 0.1)

func follow_player(): 
	if players.size() > 0:
		var player = players[0]
		target_position = player.global_position
		
