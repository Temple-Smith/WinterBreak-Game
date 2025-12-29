extends Area2D
class_name Projectile
@export var speed: float = 150.0
@export var lifetime: float = 0.25
var velocity: Vector2 = Vector2.ZERO
var elapsed: float = 0.0
func _physics_process(delta: float) -> void:
	position += velocity * delta
	elapsed += delta
	if elapsed >= lifetime:
		queue_free()
func setup(direction: Vector2) -> void:
	velocity = direction * speed
	rotation = velocity.angle()
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
func _on_area_entered(area: Area2D) -> void:
	var enemy := area.get_parent()
	if enemy is Enemy:
		enemy.take_damage(1)
		queue_free()  # destroy projectile after hitting # Replace with function body.
