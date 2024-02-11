extends Node

var player : Player = null
var level : Level = null

signal level_changed

func set_level(p_level: Level) -> void:
	level = p_level
	level_changed.emit()
