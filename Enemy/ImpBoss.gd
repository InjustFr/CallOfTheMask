extends Enemy

class_name ImpBoss

@export var cooldown := 1.0

var current_time := 0.0
var can_attack = true

func _process(delta):
	super(delta)
	current_time += delta
	if current_time >= cooldown:
		can_attack = true
		current_time = 0

func attack(target: Player):
	if can_attack:
		target.damage(damage)
		can_attack = false
