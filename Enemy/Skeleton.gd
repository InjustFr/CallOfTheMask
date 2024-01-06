extends Enemy

class_name Skeleton

@onready var projectile_scene = preload("res://Enemy/EnemyProjectile.tscn")
@onready var animation_player : AnimationPlayer = $AnimationPlayer

@export var cooldown := 1.0
@export var projectile_velocity := 32

var current_time := 0.0
var can_attack = true

var player : Player = null

func _process(delta):
	super(delta)
	if can_attack == false:
		current_time += delta
		if current_time >= cooldown:
			can_attack = true
			current_time = 0

func attack(target: Player):
	if can_attack:
		animation_player.play("attack")
		player = target
		can_attack = false

func spawn_projectile():
	if !player:
		return
	var projectile : EnemyProjectile = projectile_scene.instantiate()
	get_parent().get_parent().add_child(projectile)
	projectile.damage = 2

	var dir = (player.global_position - global_position).normalized()

	projectile.global_position = global_position
	projectile.velocity = projectile_velocity * dir
