extends Node

class_name HealthComponent

signal entity_died
signal entity_damaged
signal entity_healed

@export var max_health : int = 10
var _health : int
var _invulnerable := false


func _ready() -> void:
	_health = max_health


func take_damage(damage: int) -> void:
	if _invulnerable:
		return

	_health -= damage;
	if damage > 0:
		entity_damaged.emit()
	if damage < 0:
		entity_healed.emit()
	if _health <= 0:
		entity_died.emit()
	if _health > max_health:
		_health = max_health


func get_current_health() -> int:
	return _health


func set_invulnerable(invulnerable: bool) -> void:
	_invulnerable = invulnerable


func is_invulnerable() -> bool:
	return _invulnerable
