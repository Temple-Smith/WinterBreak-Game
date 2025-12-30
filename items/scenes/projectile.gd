extends Area2D
class_name Projectile

enum Owner { PLAYER, ENEMY }

@export var speed: float = 150.0
@export var lifetime: float = 0.25

@onready var player_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var enemy_sprite: AnimatedSprite2D = $moleProjectile

var velocity: Vector2 = Vector2.ZERO
var elapsed: float = 0.0
var projectile_owner: Owner
var is_setup: bool = false
var queued_direction: Vector2

func _ready() -> void:
	# If setup was called before _ready, finish it now
	if not is_setup and queued_direction != Vector2.ZERO:
		_finish_setup(queued_direction, projectile_owner)

func _physics_process(delta: float) -> void:
	position += velocity * delta
	elapsed += delta
	if elapsed >= lifetime:
		queue_free()

func setup(direction: Vector2, owner_type: Owner) -> void:
	projectile_owner = owner_type
	# If _ready() hasn’t run yet, queue the setup
	if not is_inside_tree():
		queued_direction = direction
		return
	
	_finish_setup(direction, owner_type)

func _finish_setup(direction: Vector2, owner_type: Owner) -> void:
	is_setup = true
	velocity = direction * speed
	rotation = velocity.angle()
	
	# Hide both first
	player_sprite.visible = false
	enemy_sprite.visible = false
	
	# Enable the correct sprite and play animation
	if owner_type == Owner.PLAYER:
		player_sprite.visible = true
		player_sprite.play("player_Projectile")
	elif owner_type == Owner.ENEMY:
		enemy_sprite.visible = true
		enemy_sprite.play("mole_Projectile")

func _on_area_entered(area: Area2D) -> void:
	var target := area.get_parent()
	
	# Miner hits enemy
	if projectile_owner == Owner.PLAYER and target is Enemy:
		target.take_damage(1)
		queue_free()
		return
	
	# Enemy hits player
	if projectile_owner == Owner.ENEMY and target.is_in_group("player"):
		target.take_damage(1)
		queue_free()
		return
