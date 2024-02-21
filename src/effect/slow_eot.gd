extends Effect

class_name SlowEffectOverTime

var slow := 40

func _init():
	duration = 5

func on_add(node: Node):
	if node is Player:
		node.speed_bonus -= slow

func on_remove(node: Node):
	if node is Player:
		node.speed_bonus += slow
