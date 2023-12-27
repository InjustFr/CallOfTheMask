extends CharacterBody2D

class_name Enemy

@export var health := 10
@export var speed := 48

@onready var sprite : AnimatedSprite2D = $AnimatedSprite2D
@onready var healthBar : TextureProgressBar = $HealthBar

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

func damage(amount: int):
	health -= amount
	if health < 0:
		queue_free()

