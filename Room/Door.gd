extends Node2D

class_name Door

@export var next_room_offset: Vector2i
var disabled = false

signal door_passed

func open() -> void:
	pass

func close() -> void:
	pass

func disable() -> void:
	pass
