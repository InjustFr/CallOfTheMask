extends Weapon

class_name ShortSword

@onready var animation_player : AnimationPlayer = $AnimationPlayer
@onready var wave_scene : PackedScene = preload("res://Projectile/SwordWave.tscn")

func _init() -> void:
	weapon_range = 64

func _ready() -> void:
	damage = 3

func use() -> void:
	if not animation_player.is_playing():
		animation_player.play('attack')


func _entity_hit(body: Node2D) -> void:
	if body is Enemy:
		body.take_damage(damage)
		enemy_hit.emit(body)

func spawn_wave() -> void:
	var wave : SwordWave = wave_scene.instantiate()
	wave.max_range = weapon_range - 24
	wave.body_entered.connect(_entity_hit)
	var player : Player = get_tree().get_root().find_children('*', 'Player', true, false)[0]
	player.get_parent().add_child(wave)

	var angle = player.get_orientation()
	wave.global_position = player.global_position + Vector2(24,0).rotated(angle)
	wave.velocity = Vector2(96,0).rotated(angle)
	wave.rotation = angle
