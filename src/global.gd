extends Node


signal level_changed
signal player_changed


var player : Player = null:
	set(p):
		player = p
		player_changed.emit()
	get:
		return player

var level : Level = null:
	set(l):
		level = l
		level_changed.emit()
	get:
		return level


