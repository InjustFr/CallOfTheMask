extends Node2D

@onready var death_menu_node : CanvasLayer = $DeathMenu
@onready var controller_label : Label = $Debug/VBoxContainer/ControllerLabel

var current_scene : Level = null
var level := 1
var is_using_controller := false

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	_launch_game()

func _input(event: InputEvent) -> void:
	is_using_controller = event is InputEventJoypadButton or event is InputEventJoypadMotion

func _process(_delta: float) -> void:
	controller_label.text = "Controller: " + ("1" if is_using_controller else "0")

func _on_level_finished() -> void:
	pass

func _on_player_died() -> void:
	get_tree().paused = true
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	death_menu_node.show()

func _launch_game() -> void:
	get_tree().paused = false
	death_menu_node.hide()
	level = 1
	var levelNode : Level = find_child("Level")

	current_scene = levelNode
	levelNode.finished.connect(_on_level_finished)

	Global.level = levelNode
	Global.player.died.connect(_on_player_died)

func _restart_game() -> void:
	for child in get_children():
		if child is Level:
			child.free()

	_launch_game()
