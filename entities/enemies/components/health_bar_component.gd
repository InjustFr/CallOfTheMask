extends TextureProgressBar


class_name HealthBarComponent


@export var health_component : HealthComponent


func _ready() -> void:
	health_component.entity_healed.connect(_update_bar)
	health_component.entity_damaged.connect(_update_bar)

	max_value = health_component.max_health
	value = health_component.max_health


func _update_bar() -> void:
	value = health_component.get_current_health()
