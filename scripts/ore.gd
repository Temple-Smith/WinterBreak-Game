extends Area2D

@export var max_hp: int = 3
var hp: int

func _ready() -> void:
	hp = max_hp

func hit(damage: int) -> void:
	hp -= damage
	if hp <= 0:
		_on_mined()

func _on_mined() -> void:
	drop_loot()
	queue_free()   

func drop_loot() -> void:
	print("Dropped ore!")
