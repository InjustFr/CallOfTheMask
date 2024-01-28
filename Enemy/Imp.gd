extends Enemy

class_name Imp

@onready var sprite : AnimatedSprite2D = $AnimatedSprite2D
@onready var aggro_collider: Area2D = $AggroRange
@onready var pathfinding_component : PathfindingComponent = $PathfindingComponent
@onready var velocity_component : VelocityComponent = $VelocityComponent
@onready var health_component : HealthComponent = $HealthComponent

var player : Player = null
var state_machine : StateMachine = StateMachine.new()


func _ready():
	aggro_collider.body_entered.connect(_on_player_entered_aggro_range)
	aggro_collider.body_exited.connect(_on_player_exited_aggro_range)

	health_component.entity_died.connect(queue_free)

	state_machine.add_state("idle", idle, idle_enter, Callable())
	state_machine.add_state("follow", follow, Callable(), Callable())
	state_machine.set_initial_state("idle")


func _physics_process(_delta):
	state_machine.update()

	if velocity:
		sprite.play("walk")
	else:
		sprite.play("idle")

	if abs(velocity.x) > 0.01:
		sprite.flip_h = velocity.x < 0

	move_and_slide()


func _on_player_entered_aggro_range(body : Node2D):
	if body is Player:
		player = body
		state_machine.change_state("follow")


func _on_player_exited_aggro_range(body : Node2D):
	if body is Player:
		player = null
		state_machine.change_state("idle")


func idle():
	pass


func idle_enter():
	velocity = Vector2(0,0)
	pathfinding_component.target = Vector2.INF


func follow():
	if player:
		pathfinding_component.target = player.global_position

	velocity = velocity_component.get_velocity()
