extends Node


class_name ProjectileSpawnerComponent


@export_file("*Projectile*") var projectile_scene_path : String
@export var projectile_speed : int


func spawn_towards_target(target: Vector2):
	var projectile_scene = load(projectile_scene_path);
	var projectile = projectile_scene.instantiate()

	var velocity_component : VelocityComponent = projectile.find_child('VelocityComponent')
	if velocity_component:
		get_parent().add_child(projectile)

		var dir = (target - get_parent().global_position).normalized()

		projectile.global_position = get_parent().global_position
		velocity_component.set_velocity(projectile_speed * dir)
