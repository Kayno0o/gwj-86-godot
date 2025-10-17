class_name StateMachine extends Node

var parent: Entity

var current_state: State
var states: Dictionary = {}

func ready(node: Entity) -> void:
	parent = node
	parent.tree_exiting.connect(_on_parent_tree_exited)

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
	if type == null: return

	change_state_type(type)

func process(delta: float) -> void:
	if not current_state:
		return

	var type = current_state.process(delta)
	if type == null: return

	change_state_type(type)

func change_state_type(type: State.Type) -> bool:
	if type == null: return false
	if not states.has(type):
		push_error("State %s does not exist" % [State.Type.find_key(type)])
		return false

	change_state(states[type])
	return true

func change_state(new_state: State) -> void:
	if current_state:
		# print_debug("from state %s to state %s" % [State.Type.find_key(current_state.type), State.Type.find_key(new_state.type)])
		current_state.exit()
	# else:
		# print_debug("to state %s" % [State.Type.find_key(new_state.type)])

	current_state = new_state
	new_state.enter()

func _on_parent_tree_exited():
	if current_state:
		current_state.exit()
