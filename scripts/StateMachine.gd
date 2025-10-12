extends Node
class_name StateMachine

## Generic state machine that manages state transitions
## States are added as children of this node

## Signal emitted when state changes
signal state_changed(from_state: String, to_state: String)

## Reference to the entity that owns this state machine
var entity: Node = null

## Current active state
var current_state: State = null

## Dictionary of all available states (state_name: State)
var states: Dictionary = {}

func _ready() -> void:
	# If entity is not set, use the parent node
	if entity == null:
		entity = get_parent()

	# Wait for all children to be ready
	await get_tree().process_frame

	# Gather all State children
	for child in get_children():
		if child is State:
			states[child.name] = child
			child.entity = entity
			child.state_machine = self

	# Enter the first state if available
	if states.size() > 0:
		var first_state_name = states.keys()[0]
		change_state(first_state_name)

## Update the current state
func update(delta: float) -> void:
	if current_state == null:
		return

	var next_state_name = current_state.update(delta)

	if next_state_name != "" and next_state_name != current_state.name:
		change_state(next_state_name)

## Change to a new state by name
func change_state(state_name: String) -> void:
	if not states.has(state_name):
		push_error("State '%s' does not exist in StateMachine" % state_name)
		return

	var previous_state_name = ""

	# Exit current state
	if current_state != null:
		previous_state_name = current_state.name
		current_state.exit()

	# Enter new state
	current_state = states[state_name]
	current_state.enter()

	state_changed.emit(previous_state_name, state_name)

## Get the name of the current state
func get_current_state_name() -> String:
	if current_state:
		return current_state.name
	return ""

## Check if currently in a specific state
func is_in_state(state_name: String) -> bool:
	return current_state != null and current_state.name == state_name
