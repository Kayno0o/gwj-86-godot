class_name StateMachine extends Node

var parent: Entity

var current_state: State
var states: Dictionary = {}

func ready(node: Entity) -> void:
	parent = node

	var init_state: State = null

	for child in get_children():
		if not child is State:
			continue

		if not init_state:
			init_state = child

		child.init(parent)
		states[child.type] = child
	
	if not init_state:
		return

	change_state(init_state)

func physics_process(delta: float) -> void:
	if not current_state:
		return

	var type = current_state.physics_process(delta)
	if type != null and states.has(type):
		change_state(states[type])

func process(delta: float) -> void:
	if not current_state:
		return

	var type = current_state.process(delta)
	if type != null and states.has(type):
		change_state(states[type])

func change_state_type(type: State.Type) -> bool:
	if type == null or not states.has(type): return false

	change_state(states[type])
	return true

func change_state(new_state: State) -> void:
	if current_state:
		current_state.exit()

	current_state = new_state
	new_state.enter()
