extends EnemyState

class_name IdleEnemyState

@export var aggro_collider: Area2D

func enter():
	aggro_collider.body_entered.connect(_player_heard)
	enemy.velocity = Vector2(0.0, 0.0)

func leave():
	aggro_collider.body_entered.disconnect(_player_heard)

func _player_heard(body: Node2D):
	if body is Player:
		transitioned.emit(self, "follow")
