extends EnemyProjectile

class_name SlowEnemyProjectile

func _on_player_hit(player: Player):
	player.add_effect_over_time(SlowEffectOverTime.new())
