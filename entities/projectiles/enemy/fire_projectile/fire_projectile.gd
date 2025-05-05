extends RigidBody2D

class_name FireProjectile


@onready var velocity_component : VelocityComponent = $VelocityComponent
@onready var sprite_2d: AnimatedSprite2D = $Sprite2D


func _ready() -> void:
	sprite_2d.play("default")

func _physics_process(delta: float) -> void:
	var collision : KinematicCollision2D = move_and_collide(
		velocity_component.velocity * delta
	)

	rotation = velocity_component.velocity.angle()

	if collision:
		queue_free()
