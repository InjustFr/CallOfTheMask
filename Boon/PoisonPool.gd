extends Area2D

var damage := 0
var duration := 0.0
var current_time := 0.0

@onready var timer = $Timer

func _ready():
	timer.timeout.connect(_on_timer_timeout)
	body_entered.connect(_on_body_entered)


func _on_body_entered(body: Node2D) -> void:
	if body is Enemy:
			body.take_damage(damage)

func _on_timer_timeout() -> void:
	if current_time >= duration:
		queue_free()
		return

	var bodies: Array[Node2D] = get_overlapping_bodies()

	for body in bodies:
		if body is Enemy:
			body.take_damage(damage)

	current_time += timer.wait_time
