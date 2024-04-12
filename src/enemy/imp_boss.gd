extends Enemy

class_name ImpBoss

@onready var projectile_scene : PackedScene = preload("res://src/projectile/enemy/enemy_projectile.tscn")
@onready var animation_player : AnimationPlayer = $AnimationPlayer

@export var cooldown := 2.0

var current_time := 0.0
var can_attack := true

var nb_projectiles_splash := 16
var projectile_spawn_radius := 16
var projectile_velocity := 32

func _process(delta: float) -> void:
	current_time += delta
	if current_time >= cooldown:
		can_attack = true
		current_time = 0

func slam_attack() -> void:
	if can_attack:
		animation_player.play("splash_attack")
		can_attack = false

func spawn_splash_projectiles() -> void:
	for i in nb_projectiles_splash:
		@warning_ignore("integer_division")
		var angle := 360 / nb_projectiles_splash * i
		var projectile : EnemyProjectile = projectile_scene.instantiate()
		projectile.velocity = Vector2(projectile_velocity, 0).rotated(
			deg_to_rad(angle)
		)
		add_child(projectile)
		projectile.global_position = global_position + Vector2(projectile_spawn_radius, 0).rotated(
			deg_to_rad(angle)
		)
