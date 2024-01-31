extends Control

@onready var room_scene = preload("res://UI/MapRoom.tscn")
@onready var empty_room_scene = preload("res://UI/EmptyMapRoom.tscn")
@onready var grid : GridContainer = $Grid

func _ready():
	Global.level_changed.connect(_generate_map)


func _process(_delta):
	if Global.player:
		var player_screen_pos = Global.player.get_global_transform_with_canvas().get_origin()
		if (position.x < player_screen_pos.x
			and player_screen_pos.x < position.x + size.x
			and position.y < player_screen_pos.y
			and player_screen_pos.y < position.y + size.y):
			modulate = Color(1, 1, 1, 0.7)
		else:
			modulate = Color(1, 1, 1, 1)

func _generate_map() -> void:
	var map = Global.level.room_map
	var map_size = Global.level.level_info.map_size
	Global.level.room_changed.connect(_room_changed)
	grid.columns = map_size.x

	for j in map_size.y:
		for i in map_size.x:
			var room;
			if !map.has(j+1) || !map[j+1].has(i+1):
				room = empty_room_scene.instantiate()
			else:
				room = room_scene.instantiate()
				room.find_child('Label', true, false).text = str(i+1) + ',' + str(j+1)
			grid.add_child(room)

	_room_changed()


func _room_changed() -> void:
	var coord: Vector2 = Global.level.current_room_pos

	grid.position = size / 2 - (coord - Vector2(1,1)) * size / 3 - size / 6
