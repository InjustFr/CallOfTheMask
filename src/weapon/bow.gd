extends Weapon

class_name Bow

@onready var animation_player : AnimationPlayer = $AnimationPlayer
@onready var arrow_scene : PackedScene = preload("res://src/projectile/arrow.tscn")


func _init() -> void:
	weapon_range = 128

func _ready() -> void:
	damage = 2

func use() -> void:
	if not animation_player.is_playing():
		animation_player.play('attack')


func _entity_hit(body: Node2D) -> void:
	body.take_damage(damage)
	enemy_hit.emit(body)

func spawn_arrow() -> void:
	var arrow : Arrow = arrow_scene.instantiate()
	arrow.max_range = 128
	arrow.enemy_hit.connect(_entity_hit)
	var player : Player = get_tree().get_root().find_children('*', 'Player', true, false)[0]
	player.get_parent().add_child(arrow)

	var angle = player.get_orientation()
	arrow.global_position = player.global_position + Vector2(12,0).rotated(angle)
	arrow.velocity = Vector2(320,0).rotated(angle)
	arrow.rotation = angle
