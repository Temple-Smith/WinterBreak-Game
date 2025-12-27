class_name Enemy extends CharacterBody2D

signal direction_changed( new_direction : Vector2)
signal enemy_damaged()

const DIR_4 = [ Vector2.RIGHT, Vector2.DOWN, Vector2.LEFT, Vector2.UP]

@export var hitPoints : int = 5

var cardinal_direction : Vector2 = Vector2.DOWN
var direction : Vector2 = Vector2.ZERO

@onready var animation_player : AnimationPlayer = $AnimationPlayer
@onready var sprite : Sprite2D = $Sprite2D
#@onready var hit_box : HitBox = $HitBox
#@onready var state_machine : EnemyStateMachine = $EnemyStateMachine

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _physics_process(delta: float) -> void:
	move_and_slide()
