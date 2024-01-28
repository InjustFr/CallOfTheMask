extends RigidBody2D

class_name EnemyProjectile

var velocity: Vector2 = Vector2.ZERO

signal player_hit


func _physics_process(delta):
	var collision : KinematicCollision2D = move_and_collide(velocity * delta)

	if collision:
		var body := collision.get_collider()
		if body is Player:
			player_hit.emit(body)
		queue_free()

