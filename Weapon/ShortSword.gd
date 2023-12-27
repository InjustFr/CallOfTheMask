extends Weapon

class_name ShortSword

var swingSpeed = 540
var attack := false
var up := true
var hit := false

func _ready():
	damage = 3
	body_entered.connect(_entity_hit)
	monitoring = false

func use():
	if !attack:
		attack = true
		up = false
		monitoring = true
		hit = false

func _physics_process(delta):
	if !attack:
		rotation = deg_to_rad(30)
		return

	var currentRotation : float = rad_to_deg(rotation)

	if round(currentRotation) < 30:
		monitoring = false
		attack = false
		return

	if round(currentRotation) > 90:
		up = true

	if up:
		rotation = deg_to_rad(currentRotation - swingSpeed * delta)
		return

	rotation = deg_to_rad(currentRotation + swingSpeed * delta)

func _entity_hit(body: Node2D):
	if body is Enemy and !hit:
		hit = true
		body.take_damage(damage)
