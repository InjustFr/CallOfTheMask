extends EnemySpawnInfo

class_name ImpSpawnInfo

const imp = preload("res://entities/enemies/imp/imp.tscn")

func get_enemies() -> Array[PackedScene]:
	return [
		imp,
		imp,
		imp,
		imp
	]
