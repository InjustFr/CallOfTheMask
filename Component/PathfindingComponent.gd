extends NavigationAgent2D


class_name PathfindingComponent


@export var velocity_component : VelocityComponent
var target : Vector2 = Vector2.INF


func _ready():
	velocity_computed.connect(_safe_velocity_calculated)
	max_speed = velocity_component.speed


func _physics_process(_delta) -> void:
	if target == Vector2.INF:
		return

	target_position = target

	var current_agent_position: Vector2 = get_parent().global_position
	var next_path_position: Vector2 = get_next_path_position()

	set_velocity(current_agent_position.direction_to(next_path_position) * velocity_component.speed)


func _safe_velocity_calculated(safe_velocity: Vector2) -> void:
	velocity_component.set_velocity(safe_velocity)
