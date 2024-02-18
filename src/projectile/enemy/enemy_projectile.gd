extends RigidBody2D

class_name EnemyProjectile


@onready var velocity_component : VelocityComponent = $VelocityComponent


func _physics_process(delta):
	var collision : KinematicCollision2D = move_and_collide(
		velocity_component.velocity * delta
	)

	if collision:
		queue_free()

