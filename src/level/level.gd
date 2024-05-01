extends Node2D

class_name Level

class RoomNode:
	var pos: Vector2i
	var children: Array[RoomNode]
	var parent: RoomNode
	var room: Room

	func _init(p_pos: Vector2i, p_parent: RoomNode, p_room: Room) -> void:
		pos = p_pos
		parent = p_parent
		room = p_room

@export var level_info : LevelResource

var start_position : Vector2i = Vector2i(4,4)

var room_map : Dictionary = {}

var total_rooms := 0
var rooms_generated : Array[RoomNode] = []
var end_rooms : Array[RoomNode] = []

var current_room_pos : Vector2i

signal finished
signal level_generated
signal room_changed

func _ready() -> void:
	_create_map()
	_generate_mandatory_rooms()
	_remove_unused_doors()
	level_generated.emit()


func _create_map() -> void:
	while rooms_generated.size() != level_info.nb_rooms:
		_clear_map()
		current_room_pos = start_position
		var node := RoomNode.new(
			start_position,
			null,
			_generate_room(start_position, level_info.start_room)
		)
		rooms_generated.push_back(node)
		_create_rooms()


func _clear_map() -> void:
	for node in rooms_generated:
		node.room.queue_free()

	rooms_generated.clear()
	end_rooms.clear()
	room_map.clear()


func _create_rooms() -> void:
	for room_node in rooms_generated:
		var nb_rooms_to_generate := randi_range(1, _get_nb_of_available_neighboor_cells(room_node.pos))

		if (!_get_nb_of_available_neighboor_cells(room_node.pos)
			||rooms_generated.size() >= level_info.nb_rooms):
			end_rooms.push_back(room_node)
			continue

		var children_positions := _get_available_neighboor_room_positions(room_node.pos)
		children_positions.shuffle()
		var nb_rooms_generated : int = 0
		for i : int in nb_rooms_to_generate:
			var child_pos := children_positions[i]
			if _get_neighboor_room_positions(child_pos).size() >= 2:
				continue

			var child_node := RoomNode.new(
				child_pos,
				room_node,
				_generate_room(child_pos)
			)
			rooms_generated.push_back(child_node)
			room_node.children.push_back(child_node)

			child_node.room.global_position = _get_next_room_position(room_node.room, child_node.room, child_node.pos - room_node.pos)

			nb_rooms_generated += 1

		if !nb_rooms_generated:
			end_rooms.push_back(room_node)


func _get_next_room_position(room: Room, next_room: Room, offset: Vector2i) -> Vector2:
	if !room:
		return Vector2(0,0)

	var room_pos := room.global_position
	var next_roomSize := next_room.get_size()
	var current_roomSize := room.get_size()

	match offset:
		Vector2i(-1, 0):
			return Vector2(room_pos.x - next_roomSize.x, room_pos.y)
		Vector2i(1, 0):
			return Vector2(room_pos.x + current_roomSize.x, room_pos.y)
		Vector2i(0, -1):
			return Vector2(room_pos.x, room_pos.y - next_roomSize.y)
		Vector2i(0, 1):
			return Vector2(room_pos.x, room_pos.y + current_roomSize.y)

	return Vector2(0,0)


func _get_nb_of_available_neighboor_cells(cell: Vector2i) -> int:
	return _get_available_neighboor_room_positions(cell).size()


func _get_available_neighboor_room_positions(cell: Vector2i) -> Array[Vector2i]:
	var neighboor_rooms :Array[Vector2i] = []
	if !_room_exists(cell + Vector2i(1, 0)) && cell.x + 1 <= level_info.map_size.x:
		neighboor_rooms.push_back(cell + Vector2i(1, 0))
	if !_room_exists(cell + Vector2i(-1, 0)) && cell.x - 1 > 0:
		neighboor_rooms.push_back(cell + Vector2i(-1, 0))
	if !_room_exists(cell + Vector2i(0, 1)) && cell.y + 1 <= level_info.map_size.y:
		neighboor_rooms.push_back(cell + Vector2i(0, 1))
	if !_room_exists(cell + Vector2i(0, -1)) && cell.y - 1 > 0:
		neighboor_rooms.push_back(cell + Vector2i(0, -1))

	return neighboor_rooms


func _get_neighboor_room_positions(cell: Vector2i) -> Array[Vector2i]:
	var neighboor_rooms :Array[Vector2i] = []
	if _room_exists(cell + Vector2i(1, 0)):
		neighboor_rooms.push_back(cell + Vector2i(1, 0))
	if _room_exists(cell + Vector2i(-1, 0)):
		neighboor_rooms.push_back(cell + Vector2i(-1, 0))
	if _room_exists(cell + Vector2i(0, 1)):
		neighboor_rooms.push_back(cell + Vector2i(0, 1))
	if _room_exists(cell + Vector2i(0, -1)):
		neighboor_rooms.push_back(cell + Vector2i(0, -1))

	return neighboor_rooms


func _room_exists(pos: Vector2i) -> bool:
	return room_map.get(pos.y) != null and room_map[pos.y].get(pos.x) != null


func _generate_room(pos: Vector2i, type: PackedScene = null) -> Room:
	if !room_map.has(pos.y):
		room_map[pos.y] = {}

	var room : Room = type.instantiate() if type else level_info.rooms[randi() % level_info.rooms.size()].instantiate()
	add_child(room)

	room_map[pos.y][pos.x] = room
	room.door_passed.connect(_on_door_passed)

	return room


func _generate_mandatory_rooms() -> void:
	end_rooms.reverse()
	for i in level_info.special_rooms.size():
		var room_node := end_rooms[i]
		var new_room := _generate_room(room_node.pos, level_info.special_rooms[i])
		room_node.room.queue_free()

		room_node.room = new_room
		new_room.global_position = _get_next_room_position(room_node.parent.room, new_room, room_node.pos - room_node.parent.pos)


func _remove_unused_doors() -> void:
	for node in rooms_generated:
		var room : Room = room_map[node.pos.y][node.pos.x]
		var positions : Array[Vector2i] = []
		if node.parent:
			positions.push_back(node.parent.pos)
		for child_node in node.children:
			positions.push_back(child_node.pos)

		room.disable_door(node.pos, positions)


func _on_door_passed(room_offset: Vector2i) -> void:
	current_room_pos += room_offset
	_setup_room()


func _setup_room() -> void:
	var p : Player = Global.player
	var room : Room = room_map[current_room_pos.y][current_room_pos.x]
	var room_pos : Vector2i = room.global_position
	var room_size : Vector2i = get_viewport().get_visible_rect().size
	p.set_camera_bounds(room_pos, room_pos + room_size)
	if p.global_position.x < room_pos.x:
		p.global_position.x = room_pos.x + 16
	if p.global_position.x >= room_pos.x + room_size.x:
		p.global_position.x = room_pos.x + room_size.x - 16
	if p.global_position.y < room_pos.y:
		p.global_position.y = room_pos.y + 16
	if p.global_position.y >= room_pos.y + room_size.y:
		p.global_position.y = room_pos.y + room_size.y - 16
	room_changed.emit()
	await get_tree().create_timer(0.5).timeout
	room.start_room()
