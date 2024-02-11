extends EnemySpawnInfo

class_name ImpSpawnInfo

const imp = preload("res://src/enemy/imp.tscn")

func get_enemies() -> Array[PackedScene]:
	return [
		imp,
		imp,
		imp,
		imp
	]
