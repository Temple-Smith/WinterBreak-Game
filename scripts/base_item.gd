@abstract 
class_name BaseItem
extends Node2D

var item_name: StringName
var price: int

func _init(item_name: StringName, price: int) -> void:
	self.item_name = item_name
	self.price = price
