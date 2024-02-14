extends Area2D

class_name ResourceCollectorComponent

@export var resource_component: ResourceComponent
@export var label: String

func _ready():
	area_entered.connect(_on_area_entered)

func _on_area_entered(area: Area2D) -> void:
	if area is ResourceCollectableComponent:
		resource_component.value += area.amount
		area.collect()
