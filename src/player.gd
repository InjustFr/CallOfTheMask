extends CharacterBody2D

class_name Player

@onready var sprite := $AnimatedSprite2D
@onready var weapon_container := $WeaponContainer
@onready var boon_collider := $BoonPickup
@onready var dash_particles : GPUParticles2D = $DashParticles
@onready var camera : Camera2D = $Camera
@onready var invulnerable_timer : Timer = $InvulnerableTimer
@onready var health_component : HealthComponent = $HealthComponent
@onready var velocity_component : VelocityComponent = $VelocityComponent
@onready var orientation_component : OrientationComponent = $OrientationComponent
@onready var target_scanner_component : FOVComponent = $FOVComponent

@export var weapon : Weapon
@export var dash_speed := 380
@export var dash_duration := 0.15
@export var dash_cooldown := 0.5

var boons := []
var resources : Dictionary = {
	"coins": 0,
	"essence": 0
}

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

func _ready() -> void:
	Global.player = self

	weapon.enemy_hit.connect(_on_enemy_hit)
	invulnerable_timer.timeout.connect(_on_invulnerable_timer_end)

	target_scanner_component.scan_range = weapon.weapon_range
	health_component.entity_died.connect(_player_died)
	health_component.entity_damaged.connect(_on_damaged)

func _player_died() -> void:
	died.emit()

func _process(_delta) -> void:
	if dashing and dash_duration * 1000 < Time.get_ticks_msec() - dash_start:
		dashing = false
		collision_layer = 2
		collision_mask = 9
		dash_end = Time.get_ticks_msec()
		dashed.emit()

func _handle_input() -> void :
	if dashing:
		return

	if Input.is_action_just_pressed("attack"):
		weapon.use()
		weapon_used.emit(self, weapon)

	if Input.is_action_just_pressed("use") and boon_collider.monitoring:
		_pickup_boon()

	if Input.is_action_just_pressed("dash"):
		_dash()


func _handle_los() -> void:
	weapon_container.rotation = orientation_component.orientation.angle()


func _physics_process(_delta) -> void:
	_handle_input()
	_handle_los()

	if velocity_component.velocity:
		velocity = velocity_component.velocity
	else:
		velocity.x = move_toward(velocity.x, 0, 80)
		velocity.y = move_toward(velocity.y, 0, 80)

	if dashing:
		if direction:
			velocity = direction.normalized() * dash_speed
		else:
			velocity = Vector2.RIGHT.rotated(get_orientation()) * dash_speed

	if velocity:
		sprite.play("walk")
	else:
		sprite.play("idle")

	if abs(velocity.x) > 0.01:
		sprite.flip_h = velocity.x < 0

	move_and_slide()

func _pickup_boon() -> void:
	for body in boon_collider.get_overlapping_bodies():
		if body is StaticBody2D and body.get_parent() is BoonSelector:
			var boon = body.get_parent().selectBoon(body)
			boon.apply(self)
			boons.push_back(boon)

func _on_damaged() -> void:
	player_hit.emit(self)
	sprite.material.set_shader_parameter("blinking", true)
	health_component.set_invulnerable(true)
	invulnerable_timer.start()

func _on_invulnerable_timer_end():
	health_component.set_invulnerable(false)
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


func get_orientation() -> float:
	return orientation_component.orientation.angle()

func update_resource(type: String, value: int) -> void:
	if resources.has(type):
		resources[type] += value;
