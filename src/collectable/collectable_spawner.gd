extends Node

class_name CollectableSpawner

@export var collectable_scene : PackedScene

@export var room: Room;
@export var spawn_min: int;
@export var spawn_max: int;
@export var center_distance: int = 16;

func spawn() -> void:
	var nb_to_spawn : int = randi_range(spawn_min, spawn_max)

	var bounding_rect: Rect2 = room.get_bounding_rect()
	var center := bounding_rect.get_center()
	for i in nb_to_spawn:
		var spawn_point := Vector2(
			randi_range(int(center.x - center_distance), int(center.x + center_distance)),
			randi_range(int(center.y - center_distance), int(center.y + center_distance))
		)

		var collectable := collectable_scene.instantiate()
		room.add_child(collectable);
		collectable.global_position = spawn_point

