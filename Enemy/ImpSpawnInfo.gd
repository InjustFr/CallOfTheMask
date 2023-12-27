extends EnemySpawnInfo

class_name ImpSpawnInfo

const imp = preload("res://Enemy/Imp.tscn")

func get_enemies() -> Array[PackedScene]:
	return [
		imp,
		imp,
		imp,
		imp
	]
