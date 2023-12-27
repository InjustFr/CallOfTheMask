extends Node2D

@onready var player_scene = preload("res://Player.tscn")
@onready var death_menu_node = $DeathMenu

var current_scene = null
var level := 1

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	_launch_game()

func _on_level_finished(succeeded: bool) -> void:
	if !succeeded:
		get_tree().paused = true
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		death_menu_node.show()

func _launch_game() -> void:
	get_tree().paused = false
	death_menu_node.hide()
	level = 1
	var level_scene := load("res://Level" + str(level) + ".tscn")
	var levelNode : Level = level_scene.instantiate()

	current_scene = levelNode
	levelNode.finished.connect(_on_level_finished)

	add_child(levelNode)

func _restart_game() -> void:
	for child in get_children():
		if child is Level:
			child.free()

	_launch_game()
