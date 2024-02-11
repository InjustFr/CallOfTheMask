extends Area2D

class_name HitBoxComponent

@export var health_component : HealthComponent

signal entity_hit

func _ready():
	area_entered.connect(_on_area_entered)


func _on_area_entered(area: Area2D) -> void:
	if area is DamageComponent:
		health_component.take_damage(area.get_damage())
		entity_hit.emit()
