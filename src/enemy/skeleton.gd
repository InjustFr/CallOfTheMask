extends Enemy

class_name Skeleton

@onready var projectile_scene := preload("res://src/projectile/enemy/enemy_projectile.tscn")
@onready var slow_projectile_scene := preload("res://src/projectile/enemy/slow_enemy_projectile.tscn")

@onready var sprite : AnimatedSprite2D = $AnimatedSprite2D
@onready var aggro_collider: Area2D = $AggroRange
@onready var animation_player : AnimationPlayer = $AnimationPlayer
@onready var pathfinding_component : PathfindingComponent = $PathfindingComponent
@onready var velocity_component : VelocityComponent = $VelocityComponent
@onready var health_component : HealthComponent = $HealthComponent
@onready var projectile_spawner_component : ProjectileSpawnerComponent = $ProjectileSpawnerComponent
@onready var orientation_component : OrientationComponent = $OrientationComponent
@onready var fov_component : FOVComponent = $FOVComponent

var player : Player = null
var state_machine : StateMachine = StateMachine.new()


func _ready() -> void:
	aggro_collider.body_entered.connect(_on_player_entered_aggro_range)
	aggro_collider.body_exited.connect(_on_player_exited_aggro_range)

	health_component.entity_died.connect(queue_free)

	state_machine.add_state("idle", idle, idle_enter, Callable())
	state_machine.add_state("follow", follow, Callable(), Callable())
	state_machine.add_state("attack", attack, attack_enter, attack_leave)
	state_machine.set_initial_state("idle")


func _physics_process(_delta: float) -> void:
	state_machine.update()
	if velocity:
		sprite.play("walk")
	else:
		sprite.play("idle")

	if abs(velocity.x) > 0.01:
		sprite.flip_h = orientation_component.orientation.x < 0

	move_and_slide()


func _on_player_entered_aggro_range(body : Node2D) -> void:
	if body is Player:
		player = body
		state_machine.change_state("follow")


func _on_player_exited_aggro_range(body : Node2D) -> void:
	if body is Player:
		player = null
		state_machine.change_state("idle")


func idle() -> void:
	pass


func idle_enter() -> void:
	velocity_component.velocity = Vector2(0,0)
	velocity = Vector2(0,0)
	pathfinding_component.target = Vector2.INF


func follow() -> void:
	if player:
		pathfinding_component.target = player.global_position

	velocity = velocity_component.velocity

	if is_instance_valid(fov_component.target) and fov_component.target is Player:
		state_machine.change_state("attack")


func attack() -> void:
	if animation_player.is_playing():
		return

	if not fov_component.target is Player:
		state_machine.change_state("follow")

	animation_player.play("attack")


func attack_enter() -> void:
	velocity = Vector2(0,0)
	velocity_component.velocity = Vector2(0,0)


func attack_leave() -> void:
	animation_player.stop()


func spawn_projectile() -> void:
	if !player:
		return

	var dir := orientation_component.orientation.normalized()

	projectile_spawner_component.spawn_towards_target(dir)

