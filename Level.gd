extends Node2D

class_name Level

@onready var mapNode : Node2D = $Map
@onready var player: Player = $Player

@export var nbRooms = 10;
@export var rooms : Array[String] = []
@export var mandatoryRooms : Array[String] = []

var loadedRooms : Array[PackedScene] = []
var loadedMandatoryRooms : Array[PackedScene] = []

var roomMap : Dictionary = {}

var totalRooms := 0
var roomsGenerated : Array[Vector2i] = []

signal finished

func _ready():
	for n in rooms:
		loadedRooms.push_back(load("res://Room/" + n + ".tscn"))
	for n in mandatoryRooms:
		loadedMandatoryRooms.push_back(load("res://Room/" + n + ".tscn"))

	_generateRandomRooms()
	_generateMandatoryRooms()

	player.died.connect(_on_player_death)


func _generateRandomRooms() -> void:
	var startingPos = Vector2i(0,0)
	roomsGenerated.push_back(startingPos)
	_generateRoom(startingPos)

	var j = 0;
	while roomsGenerated.size() < nbRooms:
		var currentRoomPos = roomsGenerated[j];
		var nbRoomsToGenerate = randi_range(1, _getNbOfAvailableNeighboorCells(currentRoomPos))

		## if no cells available around this one,
		## either backtrack if it's the last, or skip it
		if !_getNbOfAvailableNeighboorCells(currentRoomPos):
			if j == roomsGenerated.size() - 1:
				j = 0
				while !_getNbOfAvailableNeighboorCells(roomsGenerated[j]):
					j += 1
				continue

			roomsGenerated.remove_at(j)
			continue


		for i in nbRoomsToGenerate:
			if roomsGenerated.size() >= nbRooms:
				break

			var newRoomPos = _generateNeighboorRoom(currentRoomPos)

			roomsGenerated.push_back(newRoomPos)
		j += 1

func _getOffsetVector() -> Vector2i:
	var offsetX = randi_range(-1, 1)
	var offsetY = randi_range(-1, 1)

	while offsetX == 0 and offsetY == 0:
		offsetX = randi_range(-1, 1)
		offsetY = randi_range(-1, 1)

	if offsetX != 0 and offsetY != 0:
		var axis = randi_range(0, 1)
		if axis:
			offsetX = 0
		else:
			offsetY = 0
	return Vector2i(offsetX, offsetY)

func _getNextRoomPosition(currentRoom: Room, nextRoom: Room, offset: Vector2i) -> Vector2:
	if !currentRoom:
		return Vector2(0,0)

	var currentRoomPos = currentRoom.global_position
	var nextRoomSize = nextRoom.getSize()
	var currentRoomSize = currentRoom.getSize()

	match offset:
		Vector2i(-1, 0):
			var x = currentRoom.global_position.x - nextRoomSize.x
			return Vector2(currentRoomPos.x - nextRoomSize.x, currentRoomPos.y)
		Vector2i(1, 0):
			return Vector2(currentRoomPos.x + currentRoomSize.x, currentRoomPos.y)
		Vector2i(0, -1):
			return Vector2(currentRoomPos.x, currentRoomPos.y - nextRoomSize.y)
		Vector2i(0, 1):
			return Vector2(currentRoomPos.x, currentRoomPos.y + currentRoomSize.y)

	return Vector2(0,0)

func _getNbOfAvailableNeighboorCells(cell: Vector2i) -> int:
	var nb := 0

	if !_roomExists(cell + Vector2i(1, 0)):
		nb += 1
	if !_roomExists(cell + Vector2i(-1, 0)):
		nb += 1
	if !_roomExists(cell + Vector2i(0, 1)):
		nb += 1
	if !_roomExists(cell + Vector2i(0, -1)):
		nb += 1

	return nb

func _roomExists(pos: Vector2i) -> bool:
	return roomMap.get(pos.y) != null and roomMap[pos.y].get(pos.x) != null

func _generateNeighboorRoom(pos: Vector2i, type: PackedScene = null) -> Vector2i:
	var offset = _getOffsetVector()
	while (_roomExists(pos + offset)):
		offset = _getOffsetVector()

	var newRoomPos = pos + offset

	var room = _generateRoom(newRoomPos, type)
	room.global_position = _getNextRoomPosition(roomMap[pos.y][pos.x], room, offset)

	return newRoomPos

func _generateRoom(pos: Vector2i, type: PackedScene = null) -> Room:
	if !roomMap.has(pos.y):
		roomMap[pos.y] = {}

	var room : Room = type.instantiate() if type else loadedRooms[randi() % loadedRooms.size()].instantiate()
	mapNode.add_child(room)

	roomMap[pos.y][pos.x] = room

	return room

func _generateMandatoryRooms() -> void:
	for roomScene in loadedMandatoryRooms:
		var i = 0
		while !_getNbOfAvailableNeighboorCells(roomsGenerated[i]) and i < roomsGenerated.size():
			i += 1

		_generateNeighboorRoom(roomsGenerated[i], roomScene)

func _on_player_death():
	finished.emit(false)
