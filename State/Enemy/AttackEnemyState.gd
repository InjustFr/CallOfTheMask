extends EnemyState

class_name AttackEnemyState

var player: Player

func enter():
	player = enemy.lookForPlayer()
	enemy.velocity = Vector2(0,0)

func physicsUpdate(_delta):
	if (
		not enemy.lookForPlayer()
		or not enemy.weapon
		or not player.global_position.distance_to(enemy.global_position) < enemy.weapon.range
	):
		Transitioned.emit(self, "idle")
		return

	enemy.weapon.use()

