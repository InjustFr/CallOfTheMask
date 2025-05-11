extends Node

class_name EnemySpawner

@export var spawn_region: NavigationRegion2D
@export var room: Room
@export var enemies_spawning_node: Node2D

@export var enemy_spawn_sets : Array[EnemySpawnSet]

func spawn() -> void:
	var weights := []
	var weights_sum : float = 0

	for si in enemy_spawn_sets:
		weights_sum += si.weight
		weights.push_back(weights_sum)

	var choice_index := weights.bsearch(randf_range(0.0, weights_sum))

	var spawn_set := enemy_spawn_sets[choice_index]
	var enemies_to_spawn := _extract_enemy_scenes(Global.level.level_info, spawn_set)

	var navigation_map := spawn_region.get_navigation_map()
	var room_size := room.get_size()
	var top_left := room.global_position
	var bottom_right := room.global_position + Vector2(room_size)
	for enemy_scene in enemies_to_spawn:
		var point := Vector2i(randi_range(int(top_left.x), int(bottom_right.x)), randi_range(int(top_left.y), int(bottom_right.y)))
		var spawn_point := NavigationServer2D.map_get_closest_point(navigation_map, point)

		var enemy : Enemy = enemy_scene.instantiate()
		enemies_spawning_node.add_child(enemy)
		enemy.global_position = spawn_point


func _extract_enemy_scenes(level_info: LevelResource, enemy_set: EnemySpawnSet) -> Array[PackedScene]:
	var enemy_scenes: Array[PackedScene] = []
	for element in enemy_set.enemies:
		for i in range(element.amout):
			enemy_scenes.push_back(level_info.enemies[element.type])

	return enemy_scenes
