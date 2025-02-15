extends Node


class_name ProjectileSpawnerComponent


@export_file("*Projectile*") var projectile_scene_path : String
@export var projectile_speed : int


func spawn_towards_target(dir: Vector2, offset: int = 0) -> void:
	var projectile_scene := load(projectile_scene_path);
	var projectile : Node2D = projectile_scene.instantiate()

	var velocity_component : VelocityComponent = projectile.find_child('VelocityComponent')
	if velocity_component and dir != Vector2.ZERO:
		get_parent().add_child(projectile)

		projectile.global_position = get_parent().global_position + dir.normalized() * offset
		velocity_component.velocity = projectile_speed * dir.normalized()
