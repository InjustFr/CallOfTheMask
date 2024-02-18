extends Node


class_name PlayerTrackingComponent

@export var orientation_component : OrientationComponent
@export var velocity_component : VelocityComponent
@export var fov_component : FOVComponent


func _process(_delta):
	if is_instance_valid(fov_component.target) and fov_component.target is Player:
		orientation_component.orientation = (
			fov_component.target.global_position
			- get_parent().global_position
		)
	else:
		orientation_component.orientation = velocity_component.velocity
