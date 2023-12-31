extends CharacterBody2D

class_name Player

@onready var sprite := $AnimatedSprite2D
@onready var weapon_container := $WeaponContainer
@onready var boon_collider := $BoonPickup
@onready var health_bar : TextureProgressBar = $HealthBar
@onready var dash_particles : GPUParticles2D = $DashParticles
@onready var camera : Camera2D = $Camera
@onready var invulnerable_timer : Timer = $InvulnerableTimer

@export var speed := 80
@export var weapon : Weapon
@export var health := 10
@export var dash_speed := 256
@export var dash_duration := 0.15
@export var dash_cooldown := 0.5

var boons := []

var weapon_dmg := 0
var spell_dmg := 0
var speed_bonus := 0
var health_bonus := 0

var direction : Vector2 = Vector2.ZERO
var dashing := false
var dash_start := 0
var dash_end := 0
var invulnerable := false

signal died
signal player_hit
signal enemy_hit
signal dashed
signal weapon_used

func _ready():
	health_bar.max_value = health
	weapon.enemy_hit.connect(_on_enemy_hit)
	invulnerable_timer.timeout.connect(_on_invulnerable_timer_end)

func _process(_delta):
	health_bar.value = health
	if health <= 0:
		died.emit()

	if dashing and dash_duration * 1000 < Time.get_ticks_msec() - dash_start:
		dashing = false
		collision_layer = 2
		collision_mask = 9
		dash_end = Time.get_ticks_msec()
		dashed.emit()

func _physics_process(_delta):
	if not dashing:
		if Input.is_action_just_pressed("attack"):
			weapon.use()
			weapon_used.emit(self, weapon)

		if Input.is_action_just_pressed("use") and boon_collider.monitoring:
			_pickup_boon()

		if Input.is_action_just_pressed("dash"):
			_dash()

		direction = Input.get_vector("left", "right", "up", "down")

	if direction:
		velocity = direction * (speed + speed_bonus)
		if dashing:
			velocity += direction * dash_speed
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
	if invulnerable:
		return
	player_hit.emit(self)
	sprite.material.set_shader_parameter("blinking", true)
	health -= amount
	invulnerable = true
	invulnerable_timer.start()

func _on_invulnerable_timer_end():
	invulnerable = false
	sprite.material.set_shader_parameter("blinking", false)

func _on_enemy_hit(enemy: Enemy) -> void:
	enemy_hit.emit(enemy)

func _dash() -> void:
	var time_elasped = Time.get_ticks_msec() - dash_end
	if dash_cooldown * 1000 < time_elasped:
		collision_layer = 0
		collision_mask = 1
		dashing = true
		dash_start = Time.get_ticks_msec()
		dash_particles.process_material.direction = Vector3(-direction.x, -direction.y, 0.0)
		dash_particles.emitting = true

func set_camera_bounds(top_left: Vector2i, bottom_right: Vector2i) -> void:
	camera.limit_left = top_left.x
	camera.limit_top = top_left.y
	camera.limit_right = bottom_right.x
	camera.limit_bottom = bottom_right.y
