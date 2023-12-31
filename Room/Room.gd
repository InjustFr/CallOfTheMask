extends Node2D

class_name Room

signal cleared
signal door_passed
signal room_entered

@export var doors : Array[Door]

func _ready():
	cleared.connect(_on_cleared)
	room_entered.connect(_on_room_entered)
	
	for door in doors:
		door.door_passed.connect(_on_door_passed)

func getSize() -> Vector2:
	return Vector2(0,0)
	
func start_room():
	room_entered.emit()
	
func _on_cleared():
	_open_doors()

func _open_doors():
	for door in doors:
		door.open()
		
func _close_doors():
	for door in doors:
		door.close()
		
func _on_door_passed(next_room_offset: Vector2i) -> void:
	door_passed.emit(next_room_offset)

func _on_room_entered() -> void:
	_close_doors()
