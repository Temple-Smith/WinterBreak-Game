class_name Bat extends Enemy

@export var amplitude_x: float = 20.0
@export var amplitude_y: float = 10.0
@export var frequency: float = 1.0




var t: float = 0.0
var origin: Vector2 = Vector2.ZERO
var origin_set: bool = false

func _ready() -> void:
	
	current_hp = max_health
	player = get_tree().get_first_node_in_group("player")
	sprite.play("default")
	
	full_hp_width = hp_fill.size.x
	update_hp_bar()
		
func update_animation(direction: Vector2) -> void:
	if abs(direction.x) > abs(direction.y):
		if direction.x > 0:
			sprite.play("default")
		else:
			sprite.play("default")
	else:
		sprite.play("default")
		return
		
func _physics_process(delta: float) -> void:
	if is_dead:
		return
	
	match state:
		State.IDLE:
			t += delta * frequency

			# store origin once
			if not origin_set:
				origin = global_position
				origin_set = true

			# parametric figure-8 movement
			var target_pos: Vector2 = origin + Vector2(
				amplitude_x * sin(t),
				amplitude_y * sin(t) * cos(t)
			)

			# compute velocity to reach target_pos
			velocity = (target_pos - global_position) / delta
			move_and_slide()
		
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
	
	var bullets := 3
	var spread_angle := deg_to_rad(20)
	
	for i in range(bullets):
		var t: float 
		if bullets == 1:
			t = 0.0
		else:
			t = float(i) / float(bullets - 1)
		var angle_offset :float = lerp(
			-spread_angle / 2.0, 
			spread_angle / 2.0, 
			t)
	
		var bullet_dir: Vector2 = direction.rotated(angle_offset).normalized()
			
		var projectile: Projectile = projectile_scene.instantiate() as Projectile
		projectile.position = global_position + bullet_dir * 10
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
		t = 0
		origin = global_position
