extends EnemySpawnInfo

class_name SkeletonSpawnInfo

const skeleton = preload("res://src/enemy/skeleton.tscn")

func get_enemies() -> Array[PackedScene]:
	return [
		skeleton,
		skeleton,
	]
