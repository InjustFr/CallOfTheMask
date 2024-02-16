extends Node


class_name AutoAimComponent


@export var orientation_component : OrientationComponent
@export var velocity_component : VelocityComponent
@export var target_scanner_component : TargetScannerComponent


func _process(_delta):
	if is_instance_valid(target_scanner_component.target) and target_scanner_component.target is Enemy:
		orientation_component.orientation = (
			target_scanner_component.target.global_position
			- get_parent().global_position
		)
	else:
		orientation_component.orientation = velocity_component.get_velocity()
