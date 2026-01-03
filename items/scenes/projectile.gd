extends Area2D
class_name Projectile

#enum Owner { PLAYER, ENEMY }

@export var speed: float = 150.0
@export var lifetime: float = 0.25


@onready var player_sprite: AnimatedSprite2D = $AnimatedSprite2D
#@onready var enemy_sprite: AnimatedSprite2D = $moleProjectile

var damage: int = 1
var velocity: Vector2 = Vector2.ZERO
var elapsed: float = 0.0
var is_setup: bool = false
var queued_direction: Vector2

func _ready() -> void:
	if not is_setup and queued_direction != Vector2.ZERO:
		_finish_setup(queued_direction)
	

func _physics_process(delta: float) -> void:
	position += velocity * delta
	elapsed += delta
	if elapsed >= lifetime:
		queue_free()

func setup(direction: Vector2) -> void:
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
	if target.has_method("take_damage"):
		target.take_damage(damage)
		queue_free()

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("walls"):
		queue_free()
