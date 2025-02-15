extends Room

class_name EnemyRoom

@onready var navigation_region : NavigationRegion2D = $NavigationRegion2D
@onready var map : TileMap = $NavigationRegion2D/TileMap
@onready var enemy_container_node : Node2D = $Enemies
@onready var spawner_timer : Timer = $SpawnerTimer

func _ready() -> void:
	enemy_container_node.child_exiting_tree.connect(_on_enemy_death)
	super()

func get_size() -> Vector2:
	return map.get_used_rect().size * map.tile_set.tile_size

func _on_enemy_death(_body: Node2D) -> void:
	if enemy_container_node.get_children().size() - 1 == 0:
		cleared.emit()

func _on_room_entered() -> void:
	super()
	if was_cleared:
		return
	navigation_region.enabled = true
	spawner_timer.start()

func _on_room_left() -> void:
	super()
	if was_cleared:
		return
	navigation_region.enabled = false
