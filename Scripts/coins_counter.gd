extends CanvasLayer

var coins: int = 0

@onready var coins_label = $MarginContainer/HBoxContainer/Label

func _ready() -> void:
	display_coins()
	EventBus.coin_picked_up.connect(_on_coin_picked_up)

func display_coins() -> void:
	coins_label.text = str(coins)

func _on_coin_picked_up() -> void:
	coins += 1;
	display_coins()
