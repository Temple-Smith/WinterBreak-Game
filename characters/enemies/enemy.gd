class_name Enemy extends CharacterBody2D
enum State { IDLE, AGGRO }

@export var projectile_scene: PackedScene
@export var fire_rate: float = 2.0
@export var attack_range: float = 250.0
@export var speed := 10.0
@export var max_health := 30

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var hp_fill: ColorRect = $HPBar/Fill

var state: State = State.IDLE
var current_hp: int = max_health
var full_hp_width: float
var player: Node2D
var is_dead := false
var fire_cooldown: float = 0.0
var fire_timer: float = 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	current_hp = max_health
	player = get_tree().get_first_node_in_group("player")
	sprite.play("idle_Left")
	
	full_hp_width = hp_fill.size.x
	update_hp_bar()
	
func update_animation(direction: Vector2) -> void:
	if abs(direction.x) > abs(direction.y):
		if direction.x > 0:
			sprite.play("walk_Right")
		else:
			sprite.play("walk_Left")
	else:
		sprite.play("idle_Left")
		return
		
func _physics_process(delta: float) -> void:
	if is_dead:
		return
	
	match state:
		State.IDLE:
			velocity = Vector2.ZERO
			sprite.play("idle_Right")
		
		State.AGGRO:
			if player:
				var direction: Vector2 = (player.global_position - global_position).normalized()
				velocity = direction * speed
				fire_timer -= delta
				if fire_timer <= 0.0:
					fire_at_player(direction)
					fire_timer = fire_rate
				update_animation(direction)	
	move_and_slide()

func fire_at_player(direction: Vector2) -> void:
	if projectile_scene == null:
		print("Projectile scene is null for some reason")
		return
	var spread_angle: float = 0.3
	var bullets := 3
	for i in range(bullets):
		# Calculate angle offset for each bullet
		var t: float = float(i) / float(bullets - 1)  # 0..1
		var angle_offset: float = lerp(-spread_angle, spread_angle, t)
		var bullet_dir: Vector2 = direction.rotated(angle_offset).normalized()
		var projectile: Projectile = projectile_scene.instantiate()
		projectile.position = global_position
		projectile.lifetime = 2.0
		projectile.speed = 80
		projectile.setup(bullet_dir)
		get_parent().add_child(projectile)
 
func take_damage(amount: int) -> void:
	if is_dead:
		return
	current_hp -= amount
	current_hp = clamp(current_hp, 0, max_health)
	update_hp_bar()
	flash_red()
	
	const dmg_scene = preload("uid://cahrics8oxtdd")
	var dmg_instance: Node2D = dmg_scene.instantiate()
	dmg_instance.position = global_position + Vector2(0, -20)
	get_parent().add_child(dmg_instance)
	dmg_instance.setup(amount)
	
	if current_hp <= 0:
		die()
		
func update_hp_bar() -> void:
	var ratio: float = float(current_hp) / float(max_health)
	hp_fill.size.x = full_hp_width * ratio
		
func flash_red() -> void:
	sprite.modulate = Color(1,0.3,0.3)
	await get_tree().create_timer(0.1).timeout
	sprite.modulate = Color.WHITE

func die() -> void:
	is_dead = true
	queue_free()

func _on_aggro_range_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		state = State.AGGRO
		player = body

func _on_aggro_range_body_exited(body: Node2D) -> void:
	if body == player:
		state = State.IDLE
		player = null
