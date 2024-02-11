extends Boon

class_name PoisonPoolBoon

var pool_scene = preload("res://src/boon/poison_pool.tscn")

var _player : Player = null

func _init():
	label = "Poison Pool"

func apply(player: Player):
	player.dashed.connect(_on_player_dashed)
	_player = player

func reverse(player: Player):
	player.dashed.disconnect(_on_player_dashed)

func _on_player_dashed():
	var pool = pool_scene.instantiate()
	pool.damage = 1
	pool.duration = 3.0
	_player.get_parent().add_child(pool)
	pool.global_position = _player.global_position
