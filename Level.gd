extends Node2D

class_name Level

@onready var map_node : Node2D = $Map
@onready var player: Player = $Player

@export var nb_rooms = 10;
@export var rooms : Array[String] = []
@export var mandatory_rooms : Array[String] = []

var loaded_rooms : Array[PackedScene] = []
var loaded_mandatory_rooms : Array[PackedScene] = []

var room_map : Dictionary = {}

var total_rooms := 0
var rooms_generated : Array[Vector2i] = []

var current_room_pos : Vector2i

signal finished

func _ready():
	for n in rooms:
		loaded_rooms.push_back(load("res://Room/" + n + ".tscn"))
	for n in mandatory_rooms:
		loaded_mandatory_rooms.push_back(load("res://Room/" + n + ".tscn"))

	_generate_random_rooms()
	_generate_mandatory_rooms()
	_setup_room()

	player.died.connect(_on_player_death)


func _generate_random_rooms() -> void:
	var starting_pos = Vector2i(0,0)
	current_room_pos = starting_pos
	rooms_generated.push_back(starting_pos)
	_generate_room(starting_pos)

	var j = 0;
	while rooms_generated.size() < nb_rooms:
		var room_pos = rooms_generated[j];
		var nb_rooms_to_generate = randi_range(1, _get_nb_of_available_neighboor_cells(room_pos))

		## if no cells available around this one,
		## either backtrack if it's the last, or skip it
		if !_get_nb_of_available_neighboor_cells(room_pos):
			if j == rooms_generated.size() - 1:
				j = 0
				while !_get_nb_of_available_neighboor_cells(rooms_generated[j]):
					j += 1
				continue

			rooms_generated.remove_at(j)
			continue


		for i in nb_rooms_to_generate:
			if rooms_generated.size() >= nb_rooms:
				break

			var new_room_pos = _generate_neighboor_room(room_pos)

			rooms_generated.push_back(new_room_pos)
		j += 1

func _get_offset_vector() -> Vector2i:
	var offset_x = randi_range(-1, 1)
	var offset_y = randi_range(-1, 1)

	while offset_x == 0 and offset_y == 0:
		offset_x = randi_range(-1, 1)
		offset_y = randi_range(-1, 1)

	if offset_x != 0 and offset_y != 0:
		var axis = randi_range(0, 1)
		if axis:
			offset_x = 0
		else:
			offset_y = 0
	return Vector2i(offset_x, offset_y)

func _get_next_room_position(room: Room, next_room: Room, offset: Vector2i) -> Vector2:
	if !room:
		return Vector2(0,0)

	var room_pos = room.global_position
	var next_roomSize = next_room.getSize()
	var current_roomSize = room.getSize()

	match offset:
		Vector2i(-1, 0):
			var x = room.global_position.x - next_roomSize.x
			return Vector2(room_pos.x - next_roomSize.x, room_pos.y)
		Vector2i(1, 0):
			return Vector2(room_pos.x + current_roomSize.x, room_pos.y)
		Vector2i(0, -1):
			return Vector2(room_pos.x, room_pos.y - next_roomSize.y)
		Vector2i(0, 1):
			return Vector2(room_pos.x, room_pos.y + current_roomSize.y)

	return Vector2(0,0)

func _get_nb_of_available_neighboor_cells(cell: Vector2i) -> int:
	var nb := 0

	if !_room_exists(cell + Vector2i(1, 0)):
		nb += 1
	if !_room_exists(cell + Vector2i(-1, 0)):
		nb += 1
	if !_room_exists(cell + Vector2i(0, 1)):
		nb += 1
	if !_room_exists(cell + Vector2i(0, -1)):
		nb += 1

	return nb

func _room_exists(pos: Vector2i) -> bool:
	return room_map.get(pos.y) != null and room_map[pos.y].get(pos.x) != null

func _generate_neighboor_room(pos: Vector2i, type: PackedScene = null) -> Vector2i:
	var offset = _get_offset_vector()
	while (_room_exists(pos + offset)):
		offset = _get_offset_vector()

	var new_room_pos = pos + offset

	var room = _generate_room(new_room_pos, type)
	room.global_position = _get_next_room_position(room_map[pos.y][pos.x], room, offset)

	return new_room_pos

func _generate_room(pos: Vector2i, type: PackedScene = null) -> Room:
	if !room_map.has(pos.y):
		room_map[pos.y] = {}

	var room : Room = type.instantiate() if type else loaded_rooms[randi() % loaded_rooms.size()].instantiate()
	map_node.add_child(room)

	room_map[pos.y][pos.x] = room
	room.door_passed.connect(_on_door_passed)

	return room

func _generate_mandatory_rooms() -> void:
	for room_scene in loaded_mandatory_rooms:
		var i = 0
		while !_get_nb_of_available_neighboor_cells(rooms_generated[i]) and i < rooms_generated.size():
			i += 1

		_generate_neighboor_room(rooms_generated[i], room_scene)

func _on_player_death():
	finished.emit(false)

func _on_door_passed(room_offset: Vector2i) -> void: 
	current_room_pos += room_offset
	_setup_room()
	
func _setup_room() -> void:
	var p : Player = find_children("*", "Player")[0]
	print(current_room_pos)
	var room : Room = room_map[current_room_pos.y][current_room_pos.x]
	var room_pos : Vector2i = room.global_position
	var room_size : Vector2i = room.getSize()
	p.set_camera_bounds(room_pos, room_pos + room_size)
	if player.global_position.x < room_pos.x:
		player.global_position.x = room_pos.x + 16
	if player.global_position.x >= room_pos.x + room_size.x:
		player.global_position.x = room_pos.x + room_size.x - 16
	if player.global_position.y < room_pos.y:
		player.global_position.y = room_pos.y + 16
	if player.global_position.y >= room_pos.y + room_size.y:
		player.global_position.y = room_pos.y + room_size.y - 16
	await get_tree().create_timer(0.5).timeout
	room.start_room()
