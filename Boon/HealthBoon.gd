extends Boon

class_name HealthBoon

var bonus = 5;

func _init():
	label = "Health"

func apply(player: Player):
	player.healthBonus += bonus;

func reverse(player: Player):
	player.healthBonus -= bonus;
