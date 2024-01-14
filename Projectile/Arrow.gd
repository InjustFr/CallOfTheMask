extends StaticBody2D

class_name Arrow

var velocity : Vector2 = Vector2(64, 0)
var life_span : float = 0.5
var spawn_time : float = 0

signal enemy_hit

func _ready() -> void:
	spawn_time = Time.get_ticks_msec() / 1000.0

func _physics_process(delta) -> void:
	var collision : KinematicCollision2D = move_and_collide(velocity * delta)

	if collision:
		var body := collision.get_collider()
		if body is Enemy:
			enemy_hit.emit(body)
		queue_free()

	if Time.get_ticks_msec() / 1000.0 >= spawn_time + life_span:
		queue_free()
