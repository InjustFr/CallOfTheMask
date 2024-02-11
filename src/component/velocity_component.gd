extends Node

class_name VelocityComponent


@export var speed := 32
var _velocity : Vector2 = Vector2.ZERO


func get_velocity() -> Vector2:
	return _velocity


func set_velocity(velocity: Vector2) -> void:
	_velocity = velocity
