extends Area2D

@export var value: int = 10  # how much money this gives

func _ready() -> void:
	connect("area_entered", Callable(self, "_on_area_entered"))

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		Autoload.add_player_money(value)  # increment money total
		queue_free()  # remove the money
