extends CharacterBody2D

const SPEED = 100.0
@export var fire_rate: float = 0.25
@export var attack_damage: int = 5
const projectile_scene = preload("uid://bwkspd3vggkhr")
@export var max_health: int = 10
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var interaction_area: Area2D = $InteractionArea

var fire_timer: float = 0.0
var is_firing: bool = false
var fire_cooldown: float = 0.0
var is_attacking := false
var facing := "Right"
var _disable_input: bool = false
var current_health: int = max_health

func take_damage(amount: int) -> void:
	flash_red()
	current_health -= amount
	current_health = max(current_health, 0)
	
	#update the healthbar
	var ui: Control = get_tree().get_first_node_in_group("status_ui")
	if ui:
		ui.update_hp_bar()
	
	if current_health <= 0:
		die()

func flash_red() -> void:
	sprite.modulate = Color(1,0.3,0.3)
	await get_tree().create_timer(0.1).timeout
	sprite.modulate = Color.WHITE

func die() -> void:
	_disable_input = true
	queue_free()
	

func _physics_process(delta: float) -> void:
	if not _disable_input: _handle_movement()

func _process(delta: float) -> void:
	#fire cool-down for sweaty chud nerds
	if fire_cooldown > 0.0:
		fire_cooldown -= delta
	
	if fire_timer > 0.0:
		fire_timer -= delta
	
	if not _disable_input:
		handle_attack_input()
	
func handle_attack_input() -> void:
	is_firing = Input.is_action_pressed("attack")
	
	if is_firing and fire_timer <= 0:
		attack()
		fire_timer = fire_rate
	
	if not _disable_input: _handle_input()

func _handle_movement() -> void:
	if is_attacking:
		move_and_slide()
		return
	
	var direction: Vector2 = Input.get_vector("left", "right", "up", "down")
	var animation_name: String = ""
	
	if direction != Vector2.ZERO:        # Update facing ONLY for horizontal movement
		if direction.x < 0:
			facing = "Left"
		elif direction.x > 0:
			facing = "Right"
		# Set animation based on horizontal facing
		animation_name = "walk_" + facing
		# Move player
		velocity = direction * SPEED
	
	else:
		velocity = Vector2(
			move_toward(velocity.x, 0, SPEED), 
			move_toward(velocity.y, 0, SPEED)
		)
		animation_name = ("idle_" + facing)	
	
	if sprite.animation != animation_name:
		sprite.play(animation_name)
	
	move_and_slide()

func _handle_input() -> void:
	if Input.is_action_just_pressed("interact"):
		var areas: Array[Area2D] = interaction_area.get_overlapping_areas()
		if areas.size() > 0:
			for area in areas:
				if area.has_method("interact"):
					area.interact(self)

func set_disable_input(disable: bool) -> void:
	_disable_input = disable

func _on_interaction_area_area_entered(area: Area2D) -> void:
	if area.is_in_group("money"):
		var amount: int = area.get_meta("amount")
		Autoload.player_money += amount
		area.queue_free()

func attack() -> void:
	var mouse_pos: Vector2 = get_global_mouse_position()
	var direction: Vector2 = (mouse_pos - global_position).normalized()
	const SPAWN_DISTANCE: float = 10.0
	var spawn_pos: Vector2 = global_position + direction * SPAWN_DISTANCE
	var projectile: Projectile = projectile_scene.instantiate() as Projectile
	projectile.position = spawn_pos
	#Pass players current damage
	projectile.damage = attack_damage
	projectile.setup(direction, Projectile.Owner.PLAYER)
	get_parent().add_child(projectile)
	
func _on_attack_hit_box_area_entered(area: Area2D) -> void:
	var parent := area.get_parent()
	
	#Hit enemies
	if parent is Enemy:
		parent.take_damage(attack_damage)
		return
