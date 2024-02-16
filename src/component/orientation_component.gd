extends Node


class_name  OrientationComponent

@export var orientation : Vector2 = Vector2(1,0):
	set (value):
		orientation = value.normalized()
	get:
		return orientation
