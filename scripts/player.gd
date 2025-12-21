extends CharacterBody2D

const SPEED = 300.0

@onready var interaction_area: Area2D = $InteractionArea

var disable_input: bool = false

func _physics_process(delta: float) -> void:
	var direction: Vector2 = Input.get_vector("left", "right", "up", "down")
	if direction:
		velocity = direction * SPEED
	else:
		velocity = Vector2(move_toward(velocity.x, 0, SPEED), move_toward(velocity.y, 0, SPEED))

	move_and_slide()
	
func _process(delta: float) -> void:
	if disable_input: return
	if Input.is_action_just_pressed("interact"):
		var areas: Array[Area2D] = interaction_area.get_overlapping_areas()
		if areas.size() > 0 and areas[0].has_method("interact"):
			print_debug("Interacting with %s" % areas[0])
			areas[0].interact(self)
	
func set_disable_input(disable: bool) -> void:
	disable_input = disable
