extends EnemyProjectile

class_name SlowEnemyProjectile

func _on_player_hit(player: Player):
	var component : EffectHolderComponent = player.find_children(
		'*',
		'EffectHolderComponent',
		true,
		false
	)[0];
	component.add_effect(SlowEffectOverTime.new())
