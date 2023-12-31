extends Door

@onready var map: TileMap = $TileMap
@onready var door_area : Area2D = $PassingDoorArea

func _ready():
	door_area.body_entered.connect(_on_body_entered)
	
func open() -> void:
	door_area.monitoring = true
	map.set_cell(0, Vector2i(0, -2), 0, Vector2i(1, 10), 0)
	map.set_cell(0, Vector2i(0, -1), 0, Vector2i(-1, -1), 0)
	map.set_cell(0, Vector2i(0, 0), 0, Vector2i(1, 8), 0)

func close() -> void:
	door_area.monitoring = false
	map.set_cell(0, Vector2i(0, -2), 0, Vector2i(2, 9), 0)
	map.set_cell(0, Vector2i(0, -1), 0, Vector2i(2, 9), 0)
	map.set_cell(0, Vector2i(0, 0), 0, Vector2i(2, 9), 0)

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		door_passed.emit(next_room_offset)
