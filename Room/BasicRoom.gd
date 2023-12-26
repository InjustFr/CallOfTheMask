extends Room

class_name BasicRoom

@onready var map : TileMap = $NavigationRegion2D/TileMap

func getSize():
	return map.get_used_rect().size * map.tile_set.tile_size
