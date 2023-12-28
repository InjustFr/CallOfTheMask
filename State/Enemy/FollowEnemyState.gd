extends EnemyState

class_name EnemyFollowState

@export var aggro_collider: Area2D
@export var navigation: NavigationAgent2D

var player: Player;

func enter():
	aggro_collider.body_exited.connect(_player_exited)
	navigation.velocity_computed.connect(_safe_velocity_calculated)
	navigation.max_speed = enemy.speed
	player = enemy.get_player()

func leave():
	aggro_collider.body_exited.disconnect(_player_exited)
	navigation.velocity_computed.disconnect(_safe_velocity_calculated)

func physics_update(_delta):
	var direction := enemy.global_position.direction_to(player.global_position)
	if abs(direction.x) > 0:
		enemy.sprite.flip_h = direction.x < 0

	if enemy.global_position.distance_to(player.global_position) <= enemy.attack_range:
		transitioned.emit(self, "attack")
		return

	navigation.target_position = player.global_position

	var current_agent_position: Vector2 = enemy.global_position
	var next_path_position: Vector2 = navigation.get_next_path_position()

	navigation.set_velocity(current_agent_position.direction_to(next_path_position) * enemy.speed)

func _player_exited(body: Node2D):
	if body is Player:
		transitioned.emit(self, "idle")

func _safe_velocity_calculated(safe_velocity: Vector2) -> void:
	enemy.velocity = safe_velocity
