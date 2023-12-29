extends EnemyState

class_name AttackEnemyState

var player: Player

@export var attack_range_collider : Area2D

func enter():
	player = enemy.get_player()
	enemy.velocity = Vector2(0,0)

func update(_delta):
	if enemy.is_player_in_attack_range():
		enemy.attack(player)
	else:
		transitioned.emit(self, "follow")

