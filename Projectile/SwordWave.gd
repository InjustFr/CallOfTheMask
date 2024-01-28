extends RigidBody2D

class_name SwordWave

var velocity : Vector2 = Vector2(16, 0)
var max_range : float = 0.5
var distance_traveled : float = 0.0


func _physics_process(delta):
	distance_traveled += (velocity * delta).length()

	move_and_collide(velocity * delta)

	if distance_traveled >= max_range:
		queue_free()
