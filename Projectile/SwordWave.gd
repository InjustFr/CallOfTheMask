extends Area2D

class_name SwordWave

var velocity : Vector2 = Vector2(16, 0)
var life_span : float = 0.3
var spawn_time : float = 0

func _ready():
	spawn_time = Time.get_ticks_msec() / 1000.0

func _physics_process(delta):
	position += delta * velocity
	if Time.get_ticks_msec() / 1000.0 >= spawn_time + life_span:
		queue_free()
