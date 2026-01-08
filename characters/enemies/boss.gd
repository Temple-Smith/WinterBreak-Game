extends Enemy

enum BossState {
	IDLE,
	JUMPING,
	SHOOTING,
	RECOVER
}

var bossState: BossState = BossState.IDLE
var is_aggroed := false

#var knockback_velocity: Vector2 = Vector2.ZERO
#var current_hp: int = max_health
#var full_hp_width: float
##var player: Node2D
#var is_dead := false
#var fire_cooldown: float = 0.0
#var fire_timer: float = 0.0
#
#@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
#@onready var hp_fill: ColorRect = $HPBar/Fill

@export var jump_horizontal_speed: int = 200
@export var bullet_scene: PackedScene
@export var bullet_speed: int = 100
@export var spread_angle: float = 15.0
@export var lunge_speed := 200
@export var lunge_duration := 0.3

#@onready var player: CharacterBody2D = get_tree().get_first_node_in_group("player")

func jump_towards_player() -> void:
	if not player:
		return

	var dir := (player.global_position - global_position).normalized()
	velocity = dir * lunge_speed
	bossState = BossState.JUMPING

	await get_tree().create_timer(lunge_duration).timeout

	velocity = Vector2.ZERO
	bossState = BossState.RECOVER
	recover()

	
	
func fire_at_player(direction: Vector2) -> void:
	if not player:
		return
	
	var bullet: Node2D = bullet_scene.instantiate()
	bullet.global_position = $BulletSpawn.global_position
	
	var dir: = (player.global_position - global_position).normalized()
	bullet.velocity = dir * bullet_speed
	
	get_tree().current_scene.add_child(bullet)

func fire_radial(bullet_count := 12, speed := 20.0) -> void:
	if not bullet_scene:
		return

	var step := TAU / bullet_count

	for i in bullet_count:
		var angle := step * i
		var dir := Vector2(cos(angle), sin(angle))

		var projectile: Node2D = bullet_scene.instantiate() as Projectile
		projectile.global_position = global_position
		projectile.speed = speed
		projectile.lifetime = 4.0
		projectile.setup(dir, projectile.Owner.ENEMY)
		#projectile.velocity = dir * speed


		get_tree().current_scene.add_child(projectile)

func fire_burst(count: = 5, spread := 15.0) -> void:
	bossState = BossState.SHOOTING
	
	for i in count:
		fire_radial(spread)
		await get_tree().create_timer(0.25).timeout

	bossState = BossState.RECOVER
	recover()

func update_hp_bar() -> void:
	var ratio: float = float(current_hp) / float(max_health)
	hp_fill.size.x = full_hp_width * ratio

#func flash_red() -> void:
	#sprite.modulate = Color(1,0.3,0.3)
	#await get_tree().create_timer(0.1).timeout
	#sprite.modulate = Color.WHITE

func take_damage(amount: int) -> void:
	if is_dead:
		return
	current_hp -= amount
	current_hp = clamp(current_hp, 0, max_health)
	update_hp_bar()
	#flash_red()
	
	const dmg_scene = preload("uid://cahrics8oxtdd")
	var dmg_instance: Node2D = dmg_scene.instantiate()
	dmg_instance.position = global_position + Vector2(0, -20)
	get_parent().add_child(dmg_instance)
	dmg_instance.setup(amount)
	
	if current_hp <= 0:
		die()

func die() -> void:
	is_dead = true
	queue_free()

func decide_next_action() -> void:
	if not is_aggroed:
		bossState = BossState.IDLE
		velocity = Vector2.ZERO
		return
	
	match randi() % 2:
		0:
			jump_towards_player()
		1:
			fire_radial(12, 20.0)
			bossState = BossState.RECOVER
			recover()

func recover() -> void:
	await get_tree().create_timer(0.6).timeout
	decide_next_action()

	
func _physics_process(delta: float) -> void:	
	move_and_slide()
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	bossState = BossState.IDLE
	velocity = Vector2.ZERO
	max_health = 300
	current_hp = max_health
	full_hp_width = hp_fill.size.x
	update_hp_bar()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	


func _on_aggro_range_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") and not is_aggroed:
		is_aggroed = true
		player = body
		decide_next_action() # Replace with function body.


func _on_aggro_range_body_exited(body: Node2D) -> void:
	if body == player:
		is_aggroed = false
		bossState = BossState.IDLE
		velocity = Vector2.ZERO # Replace with function body.
