extends Area2D

class_name ResourceCollectableComponent

@export var amount: int = 1
@export var label: String

signal resource_collected

func collect() -> void:
	resource_collected.emit()
