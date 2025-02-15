extends Node

class_name ResourceComponent

signal resource_changed

var value: int = 0 :
	set (v):
		value = v
		resource_changed.emit(value)
	get:
		return value

