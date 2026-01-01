extends Node2D

@export var float_speed: float = 30.0    # pixels/sec upward
@export var lifetime: float = 0.8        # seconds
@export var digit_spacing: float = 14.0  # pixels between digits


var elapsed: float = 0.0
var sprite_sheet: Texture2D = preload("uid://ce8nh400r1ed7")

# Call this to show a number
func setup(number: int) -> void:
	var digits_str: String = str(number)
	var total_width: float = digits_str.length() * digit_spacing
	var start_x: float = -total_width / 2 + digit_spacing / 2
	
	for child in $Digits.get_children():
		child.queue_free()
	
	for i in range(digits_str.length()):
		var digit: int = int(digits_str[i])
		var sprite: Sprite2D = Sprite2D.new()
		sprite.texture = sprite_sheet
		sprite.region_enabled = true
		
		# I wasn't thinking when I made the spritesheet so... yeah. Can be refactored later.
		# Adjust indexing for 1–9, then 0
		var frame_index: int = digit - 1  # 1–9 becomes 0–8
		if digit == 0:
			frame_index = 9          # 0 is the last frame
		
		sprite.region_rect = Rect2(frame_index * 16, 0, 16, 16)
		sprite.position.x = start_x + i * digit_spacing
		$Digits.add_child(sprite)

func _process(delta: float) -> void:
	elapsed += delta
	position.y -= float_speed * delta
	modulate.a = clamp(1.0 - elapsed / lifetime, 0, 1)
	if elapsed >= lifetime:
		queue_free()
