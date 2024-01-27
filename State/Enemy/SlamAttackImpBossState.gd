extends EnemyState

class_name SlamAttackImpBossState

@export var attack_range_collider : Area2D

func enter():
	enemy.velocity = Vector2(0,0)

func update(_delta):
	if enemy.is_player_in_attack_range():
		enemy.slam_attack()
	else:
		transitioned.emit(self, "follow")

