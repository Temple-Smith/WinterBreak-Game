extends CharacterBody2D

const SPEED = 100.0
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var interaction_area: Area2D = $InteractionArea
@onready var slash_sprite: AnimatedSprite2D = $SlashSprite

var is_attacking := false
var facing := "Right"
var _disable_input: bool = false

func _physics_process(delta: float) -> void:
	if not _disable_input: _handle_movement()

func _process(delta: float) -> void:
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
	if Input.is_action_just_pressed("attack"):
		attack()
	
	if Input.is_action_just_pressed("interact"):
		var areas: Array[Area2D] = interaction_area.get_overlapping_areas()
		if areas.size() > 0 and areas[0].has_method("interact"):
			areas[0].interact(self)

func set_disable_input(disable: bool) -> void:
	_disable_input = disable

func _on_interaction_area_area_entered(area: Area2D) -> void:
	if area.is_in_group("money"):
		var amount: int = area.get_meta("amount")
		Autoload.player_money += amount
		area.queue_free()

func attack() -> void:
	const ATTACK_DISTANCE: float = 14.0  # in pixels
	is_attacking = true
	velocity = Vector2.ZERO
	
	slash_sprite.visible = true
	slash_sprite.play("attack_" + facing)
	
	#flip hitbox depending on faced direction
	var offset_x: float = abs($AttackHitBox.position.x)
	if facing == "Right":
		$AttackHitBox.position.x = ATTACK_DISTANCE
		slash_sprite.position.x = ATTACK_DISTANCE
		slash_sprite.scale.x = 1
	else:
		$AttackHitBox.position.x = -ATTACK_DISTANCE
		slash_sprite.position.x = -ATTACK_DISTANCE
	$AttackHitBox.position.x = abs($AttackHitBox.position.x) * (-1 if facing == "right" else 1)
	
	$AttackHitBox.monitoring = true

func _on_slash_sprite_animation_finished() -> void:
	slash_sprite.visible = false
	$AttackHitBox.monitoring = false
	is_attacking = false
		 # Replace with function body.
