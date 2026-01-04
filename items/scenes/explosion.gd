extends Area2D
class_name Explosion

@export var damage: int = 5
@export var knockback_force: float = 1.0
@export var lifetime: float = 0.25
#@export var explosion_scene: PackedScene = preload("uid://qsb0jou1b0jy")

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	sprite.play("explode")
	await get_tree().create_timer(0.8).timeout
	queue_free()
	
	
func _on_area_entered(area: Area2D) -> void:
	var target := area.get_parent()

	# Only damage enemies
	if target is Enemy:
		_apply_damage_and_knockback(target)

func _apply_damage_and_knockback(enemy: Enemy) -> void:
	# Damage
	if enemy.has_method("take_damage"):
		enemy.take_damage(damage)

	# Knockback (radial)
	var direction: Vector2 = (enemy.global_position - global_position).normalized()
	enemy.apply_knockback(direction, knockback_force)
