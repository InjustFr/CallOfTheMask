extends CharacterBody2D

class_name Player

@onready var sprite := $AnimatedSprite2D
@onready var weaponContainer := $WeaponContainer
@onready var boonCollider := $BoonPickup
@onready var healthBar : TextureProgressBar = $HealthBar

@export var speed := 64
@export var weapon : Weapon
@export var health := 10

var boons := []

var weaponDmg := 0
var spellDmg := 0
var speedBonus := 0
var healthBonus := 0

signal died

func _ready():
	healthBar.max_value = health

func _process(_delta):
	healthBar.value = health
	if health <= 0:
		died.emit()

func _physics_process(_delta):
	if Input.is_action_just_pressed("left_click"):
		weapon.use()

	if Input.is_action_just_pressed("use") and boonCollider.monitoring:
		_pickupBoon()

	var direction = Input.get_vector("a", "d", "w", "s")
	if direction:
		velocity = direction * (speed + speedBonus)
	else:
		velocity.x = move_toward(velocity.x, 0, (speed + speedBonus))
		velocity.y = move_toward(velocity.y, 0, (speed + speedBonus))

	if velocity:
		sprite.play("walk")
	else:
		sprite.play("idle")

	if abs(direction.x) > 0.01:
		sprite.flip_h = velocity.x < 0
		weaponContainer.scale.x = -1 if velocity.x < 0 else 1

	move_and_slide()

func _pickupBoon():
	for body in boonCollider.get_overlapping_bodies():
		if body is StaticBody2D and body.get_parent() is BoonSelector:
			var boon = body.get_parent().selectBoon(body)
			boon.apply(self)
			boons.push_back(boon)

func damage(amount: int):
	health -= amount
