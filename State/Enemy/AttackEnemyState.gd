extends EnemyState

class_name AttackEnemyState

var player: Player

func enter():
	player = enemy.get_player()
	enemy.velocity = Vector2(0,0)

func update(_delta):
	if enemy.global_position.distance_to(player.global_position) < enemy.attack_range:
		enemy.attack(player)
	else:
		transitioned.emit(self, "follow")

