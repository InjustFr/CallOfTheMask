extends StaticBody2D

class_name Arrow

var velocity : Vector2 = Vector2(64, 0)
var max_range : float = 0.5
var distance_traveled : float = 0.0

signal enemy_hit

func _physics_process(delta) -> void:
	var collision : KinematicCollision2D = move_and_collide(velocity * delta)

	if collision:
		var body := collision.get_collider()
		if body is Enemy:
			enemy_hit.emit(body)
		queue_free()

	distance_traveled += (velocity * delta).length()

	if distance_traveled >= max_range:
		queue_free()
