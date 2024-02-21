extends Node

class_name VelocityComponent


@export var speed := 32

var velocity : Vector2 = Vector2.ZERO:
	set (v):
		velocity = v
	get:
		return velocity

