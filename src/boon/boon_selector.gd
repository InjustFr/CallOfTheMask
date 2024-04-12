extends Node2D

class_name BoonSelector

@onready var icon_position_1 : Marker2D = $Pillar1/IconPosition
@onready var icon_position_2 : Marker2D = $Pillar2/IconPosition
@onready var icon_position_3 : Marker2D = $Pillar3/IconPosition
@onready var label_1 : Label = $Pillar1/Label
@onready var label_2 : Label = $Pillar2/Label
@onready var label_3 : Label = $Pillar3/Label

@onready var particles: GPUParticles2D = $SpawnParticles
@onready var pillar_particles: GPUParticles2D = $PickParticles

@export var boons : Array[String] = []

var loaded_boons : Array[Boon] = []
var selected_boons : Array[Boon] = []

func _ready() -> void:
	pillar_particles.finished.connect(_removeAfterParticles)

	for n in boons:
		loaded_boons.push_back(load("res://src/Boon/" + n + "Boon.gd").new())

	for i in 3:
		var randomBoon: = loaded_boons[randi() % 3]
		while selected_boons.find(randomBoon) != -1:
			randomBoon = loaded_boons[randi() % 3]

		selected_boons.push_back(randomBoon)

	label_1.text = selected_boons[0].label
	label_2.text = selected_boons[1].label
	label_3.text = selected_boons[2].label

	var sprite_1 := Sprite2D.new()
	sprite_1.texture = load(selected_boons[0].icon_path)
	sprite_1.scale = Vector2(0.1, 0.1)
	icon_position_1.add_child(sprite_1)

	var sprite_2 := Sprite2D.new()
	sprite_2.texture = load(selected_boons[1].icon_path)
	sprite_2.scale = Vector2(0.1, 0.1)
	icon_position_2.add_child(sprite_2)

	var sprite_3 := Sprite2D.new()
	sprite_3.texture = load(selected_boons[2].icon_path)
	sprite_3.scale = Vector2(0.1, 0.1)
	icon_position_3.add_child(sprite_3)

	particles.emitting = true

func selectBoon(pillar: StaticBody2D) -> Boon:
	var index := get_children().find(pillar);
	if index != -1:
		pillar_particles.global_position.x = pillar.global_position.x
		pillar_particles.emitting = true

		label_1.get_parent().hide()
		label_2.get_parent().hide()
		label_3.get_parent().hide()

		return selected_boons[index]

	return null

func _removeAfterParticles() -> void:
	queue_free()
	pass
