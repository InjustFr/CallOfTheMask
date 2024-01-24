extends EnemySpawnInfo

class_name ImpBossSpawnInfo

const imp_boss = preload("res://Enemy/ImpBoss.tscn")

func get_enemies() -> Array[PackedScene]:
	return [
		imp_boss,
	]
