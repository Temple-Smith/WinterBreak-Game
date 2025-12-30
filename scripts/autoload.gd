extends Node

var canvas_layer: CanvasLayer = null
var player_money: int = 69

const SPEAR = preload("uid://bmek6cablb46j")
var player_items: Array[BaseItem] = [ SPEAR ]

func get_player_money() -> int:
	return player_money

func set_player_money(new_value: int) -> void:
	player_money = new_value
