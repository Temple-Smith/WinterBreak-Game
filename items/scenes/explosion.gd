extends Area2D
class_name Explosion

@export var damage: int = 5
@export var knockback_force: float = 250.0
@export var lifetime: float = 0.25
@export var explosion_scene: PackedScene = preload("uid://qsb0jou1b0jy")

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	print("Explosion spawned")
	sprite.play("explode")
	await get_tree().create_timer(1.2).timeout
	print("Explosion still alive after 1s")
	queue_free()
	
func explode() -> void:
	var explosion := explosion_scene.instantiate()
	explosion.global_position = global_position
	get_parent().add_child(explosion)
	queue_free() # dynamite dies, explosion lives


	# Auto-destroy after animation / lifetime
	#await get_tree().create_timer(lifetime).timeout
	#queue_free()
	
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
	enemy.velocity += direction * knockback_force
