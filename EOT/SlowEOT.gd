extends EffectOverTime

class_name SlowEffectOverTime

var slow := 40

func _init():
	duration = 5

func on_add(player: Player):
	player.speed_bonus -= slow

func on_remove(player: Player):
	player.speed_bonus += slow
