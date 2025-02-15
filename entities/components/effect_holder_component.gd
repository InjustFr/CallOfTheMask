extends Timer


class_name EffectHolderComponent


var effects : Array[Effect] = []:
	get:
		return effects


func add_effect(effect: Effect) -> void:
	effect.on_add(get_parent())
	effect.start_time = Time.get_ticks_msec()
	effects.append(effect)


func _ready() -> void:
	timeout.connect(_process_effects)
	add_effect(SlowEffectOverTime.new())


func _process_effects() -> void:
	var currentTime := Time.get_ticks_msec()
	for e in effects:
		if e.start_time + e.duration <= currentTime:
			e.on_remove(get_parent())
			effects.remove_at(effects.find(e))
			continue

		e.apply(get_parent())
