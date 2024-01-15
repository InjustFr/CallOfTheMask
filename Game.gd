extends Node2D

@onready var player_scene = preload("res://Player.tscn")
@onready var death_menu_node = $DeathMenu
@onready var controller_label = $Debug/VBoxContainer/ControllerLabel

var current_scene = null
var level := 1
var is_using_controller := false

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	_launch_game()

func _input(event: InputEvent):
	is_using_controller = event is InputEventJoypadButton or event is InputEventJoypadMotion

func _process(_delta):
	controller_label.text = "Controller: " + ("1" if is_using_controller else "0")

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

	Global.player = find_children("*", "Player", true, false)[0]

func _restart_game() -> void:
	for child in get_children():
		if child is Level:
			child.free()

	_launch_game()
