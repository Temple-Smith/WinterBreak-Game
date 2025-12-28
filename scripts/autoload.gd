extends Node

var canvas_layer: CanvasLayer = null
var player_money: int = 67

func get_player_money() -> int:
	return player_money

func set_player_money(new_value: int) -> void:
	player_money = new_value
