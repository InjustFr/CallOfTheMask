extends HealthBarComponent


class_name BossBarComponent


func _ready() -> void:
	position = get_canvas_transform().affine_inverse() * Vector2(112,8)
	super._ready()
