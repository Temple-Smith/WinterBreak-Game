class_name Enemy extends CharacterBody2D

@export var speed := 10.0
@export var max_health := 10

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

var hp: int
var player: Node2D
var is_dead := false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hp = max_health
	player = get_tree().get_first_node_in_group("player")
	sprite.play("idle_Left")
	
func _process(delta: float) -> void:
	if not player:
		return
	
	var direction :=(player.global_position - global_position).normalized()
	velocity = speed * direction
	
	move_and_slide()
	
	update_animation(direction)
	
func update_animation(direction: Vector2) -> void:
	if abs(direction.x) > abs(direction.y):
		if direction.x > 0:
			sprite.play("walk_Right")
		else:
			sprite.play("walk_Left")
	else:
		sprite.play("walk_Left")
 	
func _physics_process(delta: float) -> void:
	move_and_slide()
	
func take_damage(amount: int) -> void:
	if is_dead:
		return
	
	hp -= amount
	flash_red()
	
	
	var dmg_scene: PackedScene = preload("res://Scenes/Effects/DamageNumber.tscn")
	var dmg_instance: Node2D = dmg_scene.instantiate()
	dmg_instance.position = global_position + Vector2(0, -20)
	get_parent().add_child(dmg_instance)
	dmg_instance.setup(amount)
	
	if hp <= 0:
		die()
		
func flash_red() -> void:
	sprite.modulate = Color(1,0.3,0.3)
	await get_tree().create_timer(0.1).timeout
	sprite.modulate = Color.WHITE

func die() -> void:
	is_dead = true
	queue_free()
