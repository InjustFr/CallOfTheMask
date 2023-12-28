extends Room

class_name BasicRoom

@onready var map : TileMap = $NavigationRegion2D/TileMap
@onready var enemy_container_node : Node2D = $Enemies

@export var doors : Array[Door]

func _ready():
	enemy_container_node.child_exiting_tree.connect(_on_enemy_death)
	cleared.connect(_on_cleared)

func getSize():
	return map.get_used_rect().size * map.tile_set.tile_size

func _on_enemy_death(_body: Node2D):
	if enemy_container_node.get_children().size() - 1 == 0:
		cleared.emit()

func _on_cleared():
	_open_doors()

func _open_doors():
	for door in doors:
		door.open()
