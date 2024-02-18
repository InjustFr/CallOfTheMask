extends Node2D


class_name  OrientationComponent


@export var orientation : Vector2 = Vector2(1,0):
	set (value):
		orientation = value.normalized()
	get:
		return orientation

@export var debug: bool = false


func _draw():
	if debug:
		draw_line(Vector2(0,0), orientation * 16, Color.RED, 1.0)


func _process(_delta):
	if debug:
		queue_redraw()
