extends Node2D

@export var float_speed: float = 30.0    # pixels/sec upward
@export var lifetime: float = 0.8        # seconds
@export var digit_spacing: float = 16.0  # pixels between digits
@export var sprite_sheet_path: String = "res://Sprites/Numbers/numbers.png"

var elapsed: float = 0.0
var sprite_sheet: Texture2D = preload("res://art/numbers/numbers-Sheet.png")

# Call this to show a number
func setup(number: int) -> void:
	var digits_str: String = str(number)
	var total_width: float = digits_str.length() * digit_spacing
	var start_x: float = -total_width / 2 + digit_spacing / 2
	
	for i in range(digits_str.length()):
		var digit: int = int(digits_str[i])
		var sprite: Sprite2D = Sprite2D.new()
		sprite.texture = sprite_sheet
		sprite.region_enabled = true
		sprite.region_rect = Rect2(0 * 16, 0, 16, 16)  # frame from sprite sheet
		sprite.position.x = start_x + i * digit_spacing
		$Digits.add_child(sprite)

func _process(delta: float) -> void:
	elapsed += delta
	position.y -= float_speed * delta
	modulate.a = clamp(1.0 - elapsed / lifetime, 0, 1)
	if elapsed >= lifetime:
		queue_free()
