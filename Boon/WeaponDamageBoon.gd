extends Boon

class_name WeaponDamageBoon

var bonus = 2;

func _init():
	label = "Weapon Damage"

func apply(player: Player):
	player.weaponDmg += bonus;

func reverse(player: Player):
	player.weaponDmg -= bonus;
