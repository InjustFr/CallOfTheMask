extends Boon

class_name HealthBoon

var bonus = 5;

func _init():
	label = "Health"

func apply(player: Player):
	player.health_bonus += bonus;

func reverse(player: Player):
	player.health_bonus -= bonus;
