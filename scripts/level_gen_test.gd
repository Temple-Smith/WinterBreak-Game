extends Node2D

var map_width: int = 256
var map_height: int = 128
var noise_scale: float = 0.08

var wall_threshold: float = 0.2
var dirt_threshold: float = 0.5
var rocky_threshold: float = 0.4

@onready var tilemap: TileMapLayer = $TileMapLayer

func generate_map() -> void:
	var noise: FastNoiseLite = FastNoiseLite.new()
	noise.seed = randi()
	noise.noise_type = FastNoiseLite.TYPE_PERLIN
	noise.frequency = noise_scale
	
	tilemap.clear()
	
	for x in range (map_width):
		for y in range(map_height):
			var noise_value: float = noise.get_noise_2d(x, y)
			noise_value = (noise_value + 1) / 2
			
			var tile_pos: Vector2i = Vector2i(x, y)
			var atlas_coords: Vector2i = Vector2i(0, 0)
			
			if noise_value < wall_threshold:
				atlas_coords = Vector2i(2,0)
			elif noise_value < dirt_threshold:
				atlas_coords = Vector2i(0,0)
			elif noise_value < rocky_threshold:
				atlas_coords = Vector2i(1,0)
			else:
				atlas_coords = Vector2i(1,0)
	
			tilemap.set_cell(tile_pos, 2, atlas_coords)
			
			
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	generate_map()# Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
