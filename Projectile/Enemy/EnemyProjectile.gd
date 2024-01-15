extends StaticBody2D

class_name EnemyProjectile

var damage : int = 1
var velocity: Vector2 = Vector2.ZERO

signal player_hit

func _ready():
	player_hit.connect(_on_player_hit)

func _physics_process(delta):
	var collision : KinematicCollision2D = move_and_collide(velocity * delta)

	if collision:
		var body := collision.get_collider()
		if body is Player:
			player_hit.emit(body)
		queue_free()

func _on_player_hit(player: Player):
	player.damage(damage)
