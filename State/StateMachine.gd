extends Node

class_name StateMachine

@export var initialState: State;

var currentState: State
var states : Dictionary = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	for child in get_children():
		if child is State:
			states[child.name.to_lower()] = child
			child.Transitioned.connect(_on_child_transitioned)

	if initialState:
		initialState.enter()
		currentState = initialState

func _process(delta):
	if currentState:
		currentState.update(delta)

func _physics_process(delta):
	if currentState:
		currentState.physicsUpdate(delta)

func _on_child_transitioned(state: State, newStateName: String):
	if state != currentState:
		return

	var newState = states.get(newStateName.to_lower())
	if !newState:
		return

	if currentState:
		currentState.leave()

	newState.enter()
	currentState = newState

