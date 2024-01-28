extends Area2D

class_name HitBoxComponent

@export var health_component : HealthComponent

signal entity_hit

func _ready():
	body_entered.connect(_on_body_entered)


func _on_body_entered(body: Node2D) -> void:
	var damage_component : DamageComponent = body.find_child('DamageComponent')

	if damage_component:
		health_component.take_damage(damage_component.get_damage())
		entity_hit.emit(body)
