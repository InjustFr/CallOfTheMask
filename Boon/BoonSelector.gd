extends Node2D

class_name BoonSelector

@onready var iconPosition1 : Marker2D = $Pillar1/IconPosition
@onready var iconPosition2 : Marker2D = $Pillar2/IconPosition
@onready var iconPosition3 : Marker2D = $Pillar3/IconPosition
@onready var label1 : Label = $Pillar1/Label
@onready var label2 : Label = $Pillar2/Label
@onready var label3 : Label = $Pillar3/Label

@onready var particles: GPUParticles2D = $SpawnParticles
@onready var pillarParticles: GPUParticles2D = $PickParticles

@export var boons : Array[String] = []

var loadedBoons : Array[Boon] = []
var selectedBoons : Array[Boon] = []

func _ready():
	pillarParticles.finished.connect(_removeAfterParticles)

	for n in boons:
		loadedBoons.push_back(load("res://Boon/" + n + "Boon.gd").new())

	for i in 3:
		var randomBoon = loadedBoons[randi() % 3]
		while selectedBoons.find(randomBoon) != -1:
			randomBoon = loadedBoons[randi() % 3]

		selectedBoons.push_back(randomBoon)

	label1.text = selectedBoons[0].label
	label2.text = selectedBoons[1].label
	label3.text = selectedBoons[2].label

	var sprite1 = Sprite2D.new()
	sprite1.texture = load(selectedBoons[0].iconPath)
	sprite1.scale = Vector2(0.1, 0.1)
	iconPosition1.add_child(sprite1)

	var sprite2 = Sprite2D.new()
	sprite2.texture = load(selectedBoons[1].iconPath)
	sprite2.scale = Vector2(0.1, 0.1)
	iconPosition2.add_child(sprite2)

	var sprite3 = Sprite2D.new()
	sprite3.texture = load(selectedBoons[2].iconPath)
	sprite3.scale = Vector2(0.1, 0.1)
	iconPosition3.add_child(sprite3)

	particles.emitting = true

func selectBoon(pillar: StaticBody2D):
	var index = get_children().find(pillar);
	if index != -1:
		pillarParticles.global_position.x = pillar.global_position.x
		pillarParticles.emitting = true

		label1.get_parent().hide()
		label2.get_parent().hide()
		label3.get_parent().hide()

		return selectedBoons[index]

	return null

func _removeAfterParticles():
	#queue_free()
	pass
