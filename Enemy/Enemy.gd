extends CharacterBody2D

class_name Enemy

@export var health := 10
@export var speed := 48
@export var damage := 1

@onready var sprite : AnimatedSprite2D = $AnimatedSprite2D
@onready var health_bar : TextureProgressBar = $HealthBar
@onready var aggro_collider: Area2D = $AggroRange
@onready var attack_range_collider: Area2D = $AttackRange

func _ready():
	sprite.play("idle")
	health_bar.max_value = health

func _process(_delta):
	health_bar.value = health

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
	for body in aggro_collider.get_overlapping_bodies():
		if body is Player:
			return body

	return null

func is_player_in_attack_range() -> bool:
	for body in attack_range_collider.get_overlapping_bodies():
		if body is Player:
			return true

	return false
