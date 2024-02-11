extends EnemySpawnInfo

class_name ImpBossSpawnInfo

const imp_boss = preload("res://src/enemy/imp_boss.tscn")

func get_enemies() -> Array[PackedScene]:
	return [
		imp_boss,
	]
