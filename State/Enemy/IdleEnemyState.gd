extends EnemyState

class_name IdleEnemyState

@export var aggroCollider: Area2D

func enter():
	aggroCollider.body_entered.connect(_playerHeard)

func leave():
	aggroCollider.body_entered.disconnect(_playerHeard)


func _playerHeard(body: Node2D):
	if body is Player:
		Transitioned.emit(self, "follow")
