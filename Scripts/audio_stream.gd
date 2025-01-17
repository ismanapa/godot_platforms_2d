extends Node

@export var number_to_play: int = 2

var random: RandomNumberGenerator =  RandomNumberGenerator.new();

func _ready() -> void:
	random.randomize()

func play():
	var audio_nodes = []
	var index
	
	for stream_player in get_children():
		if !stream_player.playing:
			audio_nodes.append(stream_player)
			
	
	for i in number_to_play:
		if audio_nodes.size() == 0:
			break
	
		index = random.randf_range(0, audio_nodes.size() - 1)
		audio_nodes[index].play()
		audio_nodes.remove_at(index)
	
	
