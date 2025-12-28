extends CharacterBody2D

const SPEED = 100.0
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var interaction_area: Area2D = $InteractionArea

var facing := "right"
var _disable_input: bool = false

func _physics_process(delta: float) -> void:
	if not _disable_input: _handle_movement()

func _process(delta: float) -> void:
	if not _disable_input: _handle_input()

func _handle_movement() -> void:
	var direction: Vector2 = Input.get_vector("left", "right", "up", "down")
	if direction.x < 0:
		facing = "right"
		velocity = direction * SPEED
		sprite.play("walk_Left")
	elif direction.x > 0:
		facing = "left"
		velocity = direction * SPEED
		sprite.play("walk_Right")
	elif direction.y > 0:
		facing = "left"
		velocity = direction * SPEED
		sprite.play("walk_Right")
	elif direction.y < 0:
		facing = "right"
		velocity = direction * SPEED
		sprite.play("walk_Left")
	else:
		velocity = Vector2(
			move_toward(velocity.x, 0, SPEED), 
			move_toward(velocity.y, 0, SPEED)
		)
		#sprite.stop()
		sprite.play("idle_" + facing)
		#sprite.frame = 0
	move_and_slide()

func _handle_input() -> void:
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
		
