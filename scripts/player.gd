extends CharacterBody2D

@onready var interaction_area: Area2D = $InteractionArea

const SPEED = 300.0
var _disable_input: bool = false

var facing_direction: Vector2

@onready var item_area: Area2D = $ItemArea

func _physics_process(delta: float) -> void:
	if !_disable_input: _handle_movement()

func _process(delta: float) -> void:
	if !_disable_input: _handle_input()
	item_area.rotation = facing_direction.angle()
	
func _set_facing_direction(direction: Vector2) -> void:
	if !direction: return
	facing_direction = direction.snapped(Vector2.ONE)
	#if Input.is_action_just_pressed("left"):
		#facing_direction = Vector2.LEFT
	#elif Input.is_action_just_pressed("right"):
		#facing_direction = Vector2.RIGHT
	#elif Input.is_action_just_pressed("down"):
		#facing_direction = Vector2.DOWN
	#elif Input.is_action_just_pressed("up"):
		#facing_direction = Vector2.UP
		#
	##if direction.x:
		##facing_direction = Vector2(direction.x, 0)
	##elif direction.y:
		##facing_direction = Vector2(0, direction.y)

func _handle_movement() -> void:
	var direction: Vector2 = Input.get_vector("left", "right", "up", "down") 
	if direction:
		velocity = direction * SPEED
	else:
		velocity = Vector2(move_toward(velocity.x, 0, SPEED), move_toward(velocity.y, 0, SPEED))
	move_and_slide()
	_set_facing_direction(direction)
	
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
