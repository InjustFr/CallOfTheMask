extends Node2D

class_name Door

@export var next_room_offset: Vector2i

signal door_passed

func open() -> void:
	pass

func close() -> void:
	pass
