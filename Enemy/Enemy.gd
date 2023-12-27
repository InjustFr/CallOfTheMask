extends CharacterBody2D

class_name Enemy

@export var health := 10
@export var speed := 48
@export var damage := 1
@export var attack_range := 16

@onready var sprite : AnimatedSprite2D = $AnimatedSprite2D
@onready var healthBar : TextureProgressBar = $HealthBar
@onready var aggroCollider: Area2D = $AggroRange

func _ready():
	sprite.play("idle")
	healthBar.max_value = health

func _process(_delta):
	healthBar.value = health

func _physics_process(_delta):
	if velocity:
		sprite.play("walk")
	else:
		sprite.play("idle")

	move_and_slide()

func take_damage(amount: int):
	health -= amount
	if health < 0:
		queue_free()

func attack(_target: Player):
	pass

func get_player() -> Player:
	for body in aggroCollider.get_overlapping_bodies():
		if body is Player:
			return body

	return null
