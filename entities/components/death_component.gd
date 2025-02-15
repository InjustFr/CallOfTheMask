extends Node

class_name DeathComponent


func die() -> void:
	get_parent().queue_free()
