extends Enemy

class_name FireSpiter

@onready var sprite : AnimatedSprite2D = $AnimatedSprite2D
@onready var animation_player : AnimationPlayer = $AnimationPlayer
@onready var health_component : HealthComponent = $HealthComponent
@onready var projectile_spawner_component : ProjectileSpawnerComponent = $ProjectileSpawnerComponent
@onready var orientation_component : OrientationComponent = $OrientationComponent
@onready var fov_component : FOVComponent = $FOVComponent
@onready var navigation_agent_2d: NavigationAgent2D = $NavigationAgent2D

@export var move_radius: int = 64
@export var min_move_radius: int = 32

var player : Player = null
var state_machine : StateMachine = StateMachine.new()


func _ready() -> void:
	health_component.entity_died.connect(queue_free)

	state_machine.add_state("idle", idle, idle_enter, Callable())
	state_machine.add_state("move", move, move_enter, move_leave)
	state_machine.add_state("attack", attack, attack_enter, attack_leave)
	state_machine.set_initial_state("idle")


func _physics_process(_delta: float) -> void:
	state_machine.update()

	if orientation_component.orientation.x > 0:
		sprite.flip_h = true
	if orientation_component.orientation.x < 0:
		sprite.flip_h = false


func _on_player_entered_aggro_range(body : Node2D) -> void:
	if body is Player:
		player = body
		state_machine.change_state("attack")


func _on_player_exited_aggro_range(body : Node2D) -> void:
	if body is Player:
		player = null
		state_machine.change_state("idle")


func idle() -> void:
	if fov_component.target is Player:
		state_machine.change_state("attack")


func idle_enter() -> void:
	animation_player.stop()
	sprite.play("idle")


func move() -> void:
	pass


func move_enter() -> void:
	animation_player.play("move_disappear")


func move_leave() -> void:
	pass


func attack() -> void:
	if not fov_component.target is Player:
		state_machine.change_state("idle")



func attack_enter() -> void:
	animation_player.play("attack")


func attack_leave() -> void:
	pass


func spawn_projectile() -> void:
	var dir := orientation_component.orientation.normalized()

	projectile_spawner_component.spawn_towards_target(dir)


func pick_spot() -> void:
	var navigation_map: RID = navigation_agent_2d.get_navigation_map()

	var new_position_direction: Vector2 = Vector2(
		randf_range(-1, 1),
		randf_range(-1, 1)
	)
	var point : Vector2 = global_position + new_position_direction * move_radius
	var spawn_point := NavigationServer2D.map_get_closest_point(navigation_map, point)
	while (global_position - spawn_point).length() < min_move_radius:
		new_position_direction = Vector2(
			randf_range(-1, 1),
			randf_range(-1, 1)
		)
		point = global_position + new_position_direction * move_radius
		spawn_point = NavigationServer2D.map_get_closest_point(navigation_map, point)

	global_position = spawn_point


func change_state(state: String) -> void:
	state_machine.change_state(state)
