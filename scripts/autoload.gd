extends Node

var canvas_layer: CanvasLayer = null
var player_money: int = 0

func get_player_money() -> int:
	return player_money

func set_player_money(new_value: int) -> void:
	player_money = new_value

func add_player_money(amount: int) -> void:
	player_money += amount
