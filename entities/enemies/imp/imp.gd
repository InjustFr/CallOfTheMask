extends Enemy

class_name Imp

@onready var sprite : AnimatedSprite2D = $AnimatedSprite2D
@onready var aggro_collider: Area2D = $AggroRange
@onready var animation_player : AnimationPlayer = $AnimationPlayer
@onready var pathfinding_component : PathfindingComponent = $PathfindingComponent
@onready var velocity_component : VelocityComponent = $VelocityComponent
@onready var health_component : HealthComponent = $HealthComponent
@onready var damage_component : DamageComponent = $DamageComponent
@onready var health_bar_component : HealthBarComponent = $HealthBarComponent
@onready var orientation_component : OrientationComponent = $OrientationComponent
@onready var fov_component: FOVComponent = $FOVComponent

var player : Player = null
var state_machine : StateMachine = StateMachine.new()
@export var offset : float
var health_bar_old_pos : Vector2
var target : Vector2


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
		sprite.flip_h = velocity.x < 0

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
	velocity = Vector2(0,0)
	velocity_component.velocity = Vector2(0,0)
	pathfinding_component.target = Vector2.INF


func follow() -> void:
	if player:
		pathfinding_component.target = player.global_position

	velocity = velocity_component.velocity

	if is_instance_valid(fov_component.target) and fov_component.target is Player:
		state_machine.change_state("attack")


func attack() -> void:
	if not fov_component.target is Player and not animation_player.is_playing():
		state_machine.change_state("follow")
		return

	if not animation_player.is_playing():
		animation_player.play("attack")

	var dir := (target - global_position).normalized()
#
	sprite.position = offset * dir
	damage_component.position = sprite.position
	health_bar_component.position = health_bar_old_pos + offset * dir


func attack_enter() -> void:
	velocity = Vector2(0,0)
	velocity_component.velocity = Vector2(0,0)
	health_bar_old_pos = health_bar_component.position
	pathfinding_component.target = Vector2.INF
	target = fov_component.target.global_position


func attack_leave() -> void:
	animation_player.stop()
	sprite.position = Vector2(0,0)
	health_bar_component.position = health_bar_old_pos
	damage_component.position = sprite.position
