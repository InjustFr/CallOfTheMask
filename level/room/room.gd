extends Node2D

class_name Room

signal cleared
signal door_passed
signal room_entered
signal room_left

@export var doors : Array[Door]

var was_cleared := false

func _ready() -> void:
	cleared.connect(_on_cleared)
	room_entered.connect(_on_room_entered)
	room_left.connect(_on_room_left)

	for door in doors:
		door.door_passed.connect(_on_door_passed)

func get_size() -> Vector2:
	return Vector2(0,0)

func get_bounding_rect() -> Rect2:
	var size := get_size()
	return Rect2(global_position, size)

func start_room() -> void:
	room_entered.emit()

func _on_cleared() -> void:
	was_cleared = true
	_open_doors()

func _open_doors() -> void:
	for door in doors:
		door.open()

func _close_doors() -> void:
	for door in doors:
		door.close()

func _on_door_passed(next_room_offset: Vector2i) -> void:
	door_passed.emit(next_room_offset)
	room_left.emit()

func _on_room_entered() -> void:
	_enable_door_detection()
	if !was_cleared:
		_close_doors()

func _on_room_left() -> void:
	_disable_door_detection()

func disable_door(pos: Vector2i, rooms: Array[Vector2i]) -> void:
	for door in doors:
		var next_pos :=  pos + door.next_room_offset
		if !rooms.has(next_pos):
			door.disable()

func _enable_door_detection() -> void:
	for door in doors:
		if !door.disabled:
			door.enable_detection()

func _disable_door_detection() -> void:
	for door in doors:
		if !door.disabled:
			door.disable_detection()
