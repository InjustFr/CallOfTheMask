extends Door

@onready var map: TileMap = $TileMap

func open() -> void:
	map.set_cell(0, Vector2i(0, -2), 0, Vector2i(1, 10), 0)
	map.set_cell(0, Vector2i(0, -1), 0, Vector2i(-1, -1), 0)
	map.set_cell(0, Vector2i(0, 0), 0, Vector2i(1, 8), 0)

func close() -> void:
	map.set_cell(0, Vector2i(0, -2), 0, Vector2i(2, 9), 0)
	map.set_cell(0, Vector2i(0, -1), 0, Vector2i(2, 9), 0)
	map.set_cell(0, Vector2i(0, 0), 0, Vector2i(2, 9), 0)
