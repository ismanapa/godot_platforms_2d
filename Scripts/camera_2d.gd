extends Camera2D

var players
var target_position = Vector2.ZERO

@export var background : Color

func _ready() -> void:
	players = get_tree().get_nodes_in_group("Player")
	
	RenderingServer.set_default_clear_color(background)

func _process(_delta: float) -> void:
		follow_player()
		global_position = lerp(target_position, global_position, 0.1)

func follow_player(): 
	if players.size() > 0:
		var player = players[0]
		target_position = player.global_position
		
