extends Room

class_name StartRoom

@onready var navigation_region : NavigationRegion2D = $NavigationRegion2D
@onready var map : TileMapLayer = $NavigationRegion2D/Walls

func _ready() -> void:
	super()
	was_cleared = true
	for d in doors:
		if not d.disabled:
			d.find_child('PassingDoorArea').monitoring = true

func get_size() -> Vector2:
	return map.get_used_rect().size * map.tile_set.tile_size

func _on_room_entered() -> void:
	super()
	if was_cleared:
		return
	navigation_region.enabled = true

func _on_room_left() -> void:
	super()
	if was_cleared:
		return
	navigation_region.enabled = false
