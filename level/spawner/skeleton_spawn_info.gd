extends EnemySpawnInfo

class_name SkeletonSpawnInfo

const skeleton = preload("res://entities/enemies/skeleton/skeleton.tscn")

func get_enemies() -> Array[PackedScene]:
	return [
		skeleton,
		skeleton,
	]
