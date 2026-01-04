extends Area2D
class_name Dynamite

@export var explosion_scene: PackedScene = preload("uid://qsb0jou1b0jy")	
@export var speed: float = 80
@export var lifetime: float = 0.85
@export var explosion_radius: float = 64
@export var damage: int = 5
@export var knockback_force: float = 200.0

var velocity: Vector2
var elapsed: float = 0.0

func setup(direction: Vector2) -> void:
	velocity = direction.normalized() * speed
	rotation = velocity.angle()

func _physics_process(delta: float) -> void:
	position += velocity * delta
	elapsed += delta
	if elapsed >= lifetime:
		explode()

func explode() -> void:
	# Spawn explosion visual + logic
	var explosion: Explosion = explosion_scene.instantiate()
	explosion.global_position = global_position
	explosion.damage = damage
	explosion.knockback_force = knockback_force
	get_parent().add_child(explosion)

	queue_free()
