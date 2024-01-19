extends Node

class_name CoinSpawner

@onready var coin_scene = preload("res://Coin.tscn")

@export var room: Room;
@export var min: int;
@export var max: int;
@export var center_distance: int = 16;

func spawn():
	var nb_to_spawn : int =randi_range(min, max)

	var bounding_rect: Rect2 = room.get_bounding_rect()
	var center = bounding_rect.get_center()
	for i in nb_to_spawn:
		var spawn_point := Vector2(
			randi_range(center.x - center_distance, center.x + center_distance),
			randi_range(center.y - center_distance, center.y + center_distance)
		)

		var coin := coin_scene.instantiate()
		room.add_child(coin);
		coin.global_position = spawn_point

