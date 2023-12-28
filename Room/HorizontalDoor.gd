extends Door

@onready var map: TileMap = $TileMap
@onready var particles : GPUParticles2D = $GPUParticles2D

func open() -> void:
	particles.emitting = true
	map.set_cell(0, Vector2i(-1, -2), 0, Vector2i(5, 15), 0)
	map.set_cell(0, Vector2i(0, -2), 0, Vector2i(6, 15), 0)
	map.set_cell(0, Vector2i(-1, -1), 0, Vector2i(5, 16), 0)
	map.set_cell(0, Vector2i(0, -1), 0, Vector2i(6, 16), 0)

func close() -> void:
	particles.emitting = true
	map.set_cell(0, Vector2i(-1, -2), 0, Vector2i(2, 15), 0)
	map.set_cell(0, Vector2i(0, -2), 0, Vector2i(3, 15), 0)
	map.set_cell(0, Vector2i(-1, -1), 0, Vector2i(2, 16), 0)
	map.set_cell(0, Vector2i(0, -1), 0, Vector2i(3, 16), 0)
