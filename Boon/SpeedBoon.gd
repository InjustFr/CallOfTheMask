extends Boon

class_name SpeedBoon

var bonus = 32;

func _init():
	label = "Speed"

func apply(player: Player):
	player.speedBonus += bonus;

func reverse(player: Player):
	player.speedBonus -= bonus;
