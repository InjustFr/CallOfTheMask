extends StaticBody2D

class_name EnemyProjectile

var damage : int = 1
var velocity: Vector2 = Vector2.ZERO

func _physics_process(delta):
	var collision : KinematicCollision2D = move_and_collide(velocity * delta)

	if collision:
		var body := collision.get_collider()
		if body is Player:
			body.damage(damage)
		queue_free()



