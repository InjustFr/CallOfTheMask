extends Door

@onready var map: TileMap = $TileMap
@onready var particles : GPUParticles2D = $GPUParticles2D
@onready var door_area : Area2D = $PassingDoorArea

func _ready():
	door_area.body_entered.connect(_on_body_entered)

func open() -> void:
	particles.emitting = true
	door_area.monitoring = true
	map.set_cell(0, Vector2i(-1, -2), 0, Vector2i(5, 15), 0)
	map.set_cell(0, Vector2i(0, -2), 0, Vector2i(6, 15), 0)
	map.set_cell(0, Vector2i(-1, -1), 0, Vector2i(5, 16), 0)
	map.set_cell(0, Vector2i(0, -1), 0, Vector2i(6, 16), 0)

func close() -> void:
	particles.emitting = true
	door_area.monitoring = false
	map.set_cell(0, Vector2i(-1, -2), 0, Vector2i(2, 15), 0)
	map.set_cell(0, Vector2i(0, -2), 0, Vector2i(3, 15), 0)
	map.set_cell(0, Vector2i(-1, -1), 0, Vector2i(2, 16), 0)
	map.set_cell(0, Vector2i(0, -1), 0, Vector2i(3, 16), 0)

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		door_passed.emit(next_room_offset)
