extends CharacterBody2D

class_name Player

@onready var sprite := $AnimatedSprite2D
@onready var weaponContainer := $WeaponContainer

@export var speed = 64
@export var weapon : Weapon

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

func _physics_process(_delta):
	if Input.is_action_just_pressed("left_click"):
		weapon.use()

	var direction = Input.get_vector("a", "d", "w", "s")
	if direction:
		velocity = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.y = move_toward(velocity.y, 0, speed)

	if velocity:
		sprite.play("walk")
	else:
		sprite.play("idle")

	if abs(direction.x) > 0.01:
		sprite.flip_h = velocity.x < 0
		weaponContainer.scale.x = -1 if velocity.x < 0 else 1

	move_and_slide()
