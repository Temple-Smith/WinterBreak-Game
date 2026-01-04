extends Area2D
class_name Projectile

@export var speed: float = 150.0
@export var lifetime: float = 0.25
enum Owner { PLAYER, ENEMY }

@onready var player_sprite: AnimatedSprite2D = $AnimatedSprite2D

var damage: int = 1
var velocity: Vector2 = Vector2.ZERO
var elapsed: float = 0.0
var is_setup: bool = false
var queued_direction: Vector2
var projectile_owner: Owner


func _ready() -> void:
	if not is_setup and queued_direction != Vector2.ZERO:
		_finish_setup(queued_direction)
	

func _physics_process(delta: float) -> void:
	position += velocity * delta
	elapsed += delta
	if elapsed >= lifetime:
		queue_free()

func setup(direction: Vector2, owner_type: Owner) -> void:
	projectile_owner = owner_type
	if not is_inside_tree():
		queued_direction = direction
		return
	
	_finish_setup(direction)

func _finish_setup(direction: Vector2) -> void:
	is_setup = true
	velocity = direction.normalized() * speed
	rotation = velocity.angle()

func _on_area_entered(area: Area2D) -> void:
	var target := area.get_parent()
	# PLAYER hits Enemy
	if projectile_owner == Owner.PLAYER and target is Enemy:
		target.take_damage(damage)
		queue_free()
		return

	# PLAYER hits Ore
	if projectile_owner == Owner.PLAYER and target is Ore:
		target.take_damage(damage)
		queue_free()
		return

	# ENEMY hits Player
	if projectile_owner == Owner.ENEMY and target.is_in_group("player"):
		target.take_damage(damage)
		queue_free()
		return
	
	# ENEMY hits Ore
	if projectile_owner == Owner.ENEMY and target is Ore:
		target.take_damage(0)
		queue_free()
		return

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("walls"):
		queue_free()
