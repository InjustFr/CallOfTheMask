extends Boon

class_name SpeedBoon

var bonus = 32;

func _init():
	label = "Speed"

func apply(player: Player):
	player.speed_bonus += bonus;

func reverse(player: Player):
	player.speed_bonus -= bonus;
