extends Node2D

class_name Door

@export var next_room_offset: Vector2i
var disabled := false

signal door_passed

func open() -> void:
	pass

func close() -> void:
	pass

func disable() -> void:
	pass

func get_tp_position() -> Vector2:
	return Vector2.ZERO

func disable_detection() -> void:
	pass

func enable_detection() -> void:
	pass
