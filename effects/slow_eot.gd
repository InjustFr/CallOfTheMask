extends Effect

class_name SlowEffectOverTime

var slow := 40

func _init() -> void:
	duration = 5

func on_add(node: Node) -> void:
	if node is Player:
		node.speed_bonus -= slow

func on_remove(node: Node) -> void:
	if node is Player:
		node.speed_bonus += slow
