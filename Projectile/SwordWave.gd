extends Area2D

class_name SwordWave

var velocity : Vector2 = Vector2(16, 0)
var max_range : float = 0.5
var distance_traveled : float = 0.0


func _physics_process(delta):
	position += delta * velocity
	distance_traveled += (velocity * delta).length()

	if distance_traveled >= max_range:
		queue_free()
