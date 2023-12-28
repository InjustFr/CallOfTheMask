extends CharacterBody2D

class_name Player

@onready var sprite := $AnimatedSprite2D
@onready var weapon_container := $weapon_container
@onready var boon_collider := $BoonPickup
@onready var health_bar : TextureProgressBar = $health_bar

@export var speed := 80
@export var weapon : Weapon
@export var health := 10

var boons := []

var weapon_dmg := 0
var spell_dmg := 0
var speed_bonus := 0
var health_bonus := 0

signal died
signal player_hit
signal enemy_hit
signal dashed
signal weapon_used

func _ready():
	health_bar.max_value = health
	weapon.enemy_hit.connect(_on_enemy_hit)

func _process(_delta):
	health_bar.value = health
	if health <= 0:
		died.emit()

func _physics_process(_delta):
	if Input.is_action_just_pressed("left_click"):
		weapon.use()
		weapon_used.emit(self, weapon)

	if Input.is_action_just_pressed("use") and boon_collider.monitoring:
		_pickup_boon()

	var direction = Input.get_vector("a", "d", "w", "s")
	if direction:
		velocity = direction * (speed + speed_bonus)
	else:
		velocity.x = move_toward(velocity.x, 0, (speed + speed_bonus))
		velocity.y = move_toward(velocity.y, 0, (speed + speed_bonus))

	if velocity:
		sprite.play("walk")
	else:
		sprite.play("idle")

	if abs(direction.x) > 0.01:
		sprite.flip_h = velocity.x < 0
		weapon_container.scale.x = -1 if velocity.x < 0 else 1

	move_and_slide()

func _pickup_boon():
	for body in boon_collider.get_overlapping_bodies():
		if body is StaticBody2D and body.get_parent() is BoonSelector:
			var boon = body.get_parent().selectBoon(body)
			boon.apply(self)
			boons.push_back(boon)

func damage(amount: int):
	player_hit.emit(self)
	health -= amount

func _on_enemy_hit(enemy: Enemy) -> void:
	enemy_hit.emit(enemy)
