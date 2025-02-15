extends EnemySpawnInfo

class_name ImpBossSpawnInfo

const imp_boss = preload("res://entities/enemies/boss/imp_boss/imp_boss.tscn")

func get_enemies() -> Array[PackedScene]:
	return [
		imp_boss,
	]
