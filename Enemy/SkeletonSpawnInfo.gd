extends EnemySpawnInfo

class_name SkeletonSpawnInfo

const skeleton = preload("res://Enemy/Skeleton.tscn")

func get_enemies() -> Array[PackedScene]:
	return [
		skeleton,
		skeleton,
	]
