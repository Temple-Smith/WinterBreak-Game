extends Area2D

@export var next_level_path: String = "uid://r1qqgs236hft"  # Path to the next level scene

func _ready() -> void:
	connect("area_entered", Callable(self, "_on_area_entered"))

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("player"):
		if next_level_path != "":
			get_tree().change_scene_to_file(next_level_path)


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		if next_level_path != "":
			get_tree().change_scene_to_file(next_level_path) # Replace with function body.
