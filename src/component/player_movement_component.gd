extends Node

class_name PlayerMovementComponent

@export var velocity_component: VelocityComponent
@export var move_speed := 25

func _physics_process(_delta: float) -> void:
	var direction := Input.get_vector("left", "right", "up", "down")
	velocity_component.velocity = direction * move_speed
