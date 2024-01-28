extends CharacterBody2D

class_name Player

@onready var sprite := $AnimatedSprite2D
@onready var weapon_container := $WeaponContainer
@onready var boon_collider := $BoonPickup
@onready var dash_particles : GPUParticles2D = $DashParticles
@onready var camera : Camera2D = $Camera
@onready var invulnerable_timer : Timer = $InvulnerableTimer
@onready var eot_timer : Timer = $EoTTimer
@onready var orientation_line : Line2D = $OrientationLine
@onready var auto_aim_ray_cast : RayCast2D = $AutoAimCast
@onready var health_component : HealthComponent = $HealthComponent
@onready var velocity_component : VelocityComponent = $VelocityComponent

@export var weapon : Weapon
@export var dash_speed := 380
@export var dash_duration := 0.15
@export var dash_cooldown := 0.5

var boons := []
var effects_over_time : Array[EffectOverTime] = []
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
	weapon.enemy_hit.connect(_on_enemy_hit)
	invulnerable_timer.timeout.connect(_on_invulnerable_timer_end)
	eot_timer.timeout.connect(_apply_effects_over_time)

	auto_aim_ray_cast.scan_range = weapon.weapon_range
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
	auto_aim_ray_cast.rotation = orientation_line.rotation
	var nearest : Node2D = auto_aim_ray_cast.scan();
	if nearest is Enemy:
		orientation_line.rotation = get_angle_to(nearest.global_position)
	elif direction:
		orientation_line.rotation = direction.normalized().angle()

	weapon_container.rotation = orientation_line.rotation


func _physics_process(_delta) -> void:
	_handle_input()
	_handle_los()

	if velocity_component.get_velocity():
		velocity = velocity_component.get_velocity()
	else:
		velocity.x = move_toward(velocity.x, 0, 80)
		velocity.y = move_toward(velocity.y, 0, 80)

	if dashing:
		if direction:
			velocity = direction.normalized() * dash_speed
		else:
			velocity = Vector2.RIGHT.rotated(orientation_line.rotation) * dash_speed

	if velocity:
		sprite.play("walk")
	else:
		sprite.play("idle")

	if abs(direction.x) > 0.01:
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

func add_effect_over_time(effect: EffectOverTime) -> void:
	effects_over_time.push_back(effect)
	effect.on_add(self)

func _apply_effects_over_time() -> void:
	for effect in effects_over_time:
		effect.apply(self)
		if effect.current_time >= effect.duration:
			effects_over_time.remove_at(effects_over_time.find(effect))
			effect.on_remove(self)
			effect.queue_free()
			continue

		effect.current_time += eot_timer.wait_time

func get_orientation() -> float:
	return orientation_line.rotation

func update_resource(type: String, value: int) -> void:
	if resources.has(type):
		resources[type] += value;
