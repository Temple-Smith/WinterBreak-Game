class_name Ore extends StaticBody2D

enum Owner { PLAYER, ENEMY }

@export var max_health: int = 5
var current_hp: int
var projectile_Owner: Owner 
func _ready() -> void:
	current_hp = max_health

func take_damage(amount: int) -> void:
	current_hp -= amount
	current_hp = clamp(current_hp, 0, max_health)
	print("Ore HP:", current_hp)
	if current_hp <= 0:
		_on_mined()

func _on_mined() -> void:
	drop_loot()
	queue_free()   

func drop_loot() -> void:
	print("Dropped ore!")
	var money_scene: PackedScene = preload("res://levels/props/money.tscn")  
	var money_instance: Node = money_scene.instantiate()
	get_parent().add_child(money_instance)
	money_instance.global_position = global_position
