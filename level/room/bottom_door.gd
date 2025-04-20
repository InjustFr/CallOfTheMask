extends Door

@onready var map: TileMapLayer = $Walls
@onready var particles : GPUParticles2D = $GPUParticles2D
@onready var door_area : Area2D = $PassingDoorArea

func _ready() -> void:
	door_area.body_entered.connect(_on_body_entered)

func open() -> void:
	if disabled:
		return
	particles.emitting = true
	door_area.monitoring = true
	map.set_cell(Vector2i(0, 0), 0, Vector2i(2, 7), 0)

func close() -> void:
	if disabled:
		return

	particles.emitting = true
	door_area.monitoring = false
	map.set_cell(Vector2i(0, 0), 0, Vector2i(2, 9), 0)

func disable() -> void:
	disabled = true
	door_area.monitoring = false
	map.set_cell(Vector2i(-1, 0), 0, Vector2i(2, 5), 0)
	map.set_cell(Vector2i(0, 0), 0, Vector2i(3, 5), 0)

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		door_passed.emit(next_room_offset)

func disable_detection() -> void:
	door_area.set_deferred("monitoring", false)

func enable_detection() -> void:
	door_area.monitoring = true
