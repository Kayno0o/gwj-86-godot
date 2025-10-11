extends Node

# signal emitted when a new target becomes available
signal target_available(target: Node, target_types: Array[String])

# signal emitted when a target is destroyed/removed
signal target_removed(target: Node)

# dictionary to store targets by type
# format: { "tree": [target1, target2], "item": [item1, item2] }
var _targets_by_type: Dictionary = {}

# dictionary to track which node is targeting which object
# format: { target_node: node }
var _target_assignments: Dictionary = {}

func _ready() -> void:
	# initialize common target types
	_targets_by_type["tree"] = []
	_targets_by_type["rock"] = []
	_targets_by_type["item"] = []

## register a target that can be interacted with
## target_types: Array of strings like ["tree", "wood_resource"]
func register_target(target: Node, target_types: Array[String]) -> void:
	if not is_instance_valid(target):
		return
	
	# add to each type category
	for type in target_types:
		if not _targets_by_type.has(type):
			_targets_by_type[type] = []
		
		if target not in _targets_by_type[type]:
			_targets_by_type[type].append(target)
	
	# emit signal so interested nodes can react
	target_available.emit(target, target_types)
	
	# connect to the target's tree_exiting signal to auto-unregister
	if not target.tree_exiting.is_connected(_on_target_destroyed):
		target.tree_exiting.connect(_on_target_destroyed.bind(target, target_types))

## unregister a target (called automatically on destruction)
func unregister_target(target: Node, target_types: Array[String]) -> void:
	if not is_instance_valid(target):
		return
	
	# remove from all type categories
	for type in target_types:
		if _targets_by_type.has(type) and target in _targets_by_type[type]:
			_targets_by_type[type].erase(target)
	
	# clear assignment if this target was being targeted
	if _target_assignments.has(target):
		_target_assignments.erase(target)

	target_removed.emit(target)

## get all targets of specific types (returns unique targets only)
func get_targets_of_type(target_types: Array[String]) -> Array[Node]:
	var results: Array[Node] = []
	var seen: Dictionary = {}

	for type in target_types:
		if _targets_by_type.has(type):
			for target in _targets_by_type[type]:
				if not seen.has(target):
					results.append(target)
					seen[target] = true

	return results

## get the nearest available target to a position
func get_nearest_available_target(
	position: Vector2,
	target_types: Array[String],
	requester: Node
) -> Node:
	var candidates = get_targets_of_type(target_types)
	var nearest: Node = null
	var nearest_distance: float = INF

	for candidate in candidates:
		if not is_instance_valid(candidate):
			# clean up invalid targets
			_cleanup_invalid_target(candidate)
			continue

		# check if target is already assigned to another node
		if _target_assignments.has(candidate):
			# validate the assigned node still exists
			var assigned_node = _target_assignments[candidate]
			if not is_instance_valid(assigned_node):
				# node no longer exists, release the target
				_target_assignments.erase(candidate)
			elif assigned_node != requester:
				# target is assigned to a different valid node
				continue

		var distance = position.distance_to(candidate.global_position)
		if distance < nearest_distance:
			nearest = candidate
			nearest_distance = distance

	return nearest

## internal: Clean up an invalid target from all tracking dictionaries
func _cleanup_invalid_target(target: Node) -> void:
	# remove from type categories
	for type in _targets_by_type.keys():
		if target in _targets_by_type[type]:
			_targets_by_type[type].erase(target)

	# remove from assignments
	if _target_assignments.has(target):
		_target_assignments.erase(target)

## assign a node to a target (updates tracking)
func assign_target(target: Node, node: Node) -> bool:
	if not is_instance_valid(target) or not is_instance_valid(node):
		return false

	# check if already assigned to another node
	if _target_assignments.has(target) and _target_assignments[target] != node:
		return false

	_target_assignments[target] = node

	# connect to node's tree_exiting signal to auto-release target when node is destroyed
	if not node.tree_exiting.is_connected(_on_node_destroyed):
		node.tree_exiting.connect(_on_node_destroyed.bind(target, node))

	return true

## release a target assignment (optionally specify which node to release from)
func release_target(target: Node, node: Node = null) -> void:
	if not is_instance_valid(target):
		return

	# if node is specified, only release if this node owns the target
	if node != null:
		if _target_assignments.get(target) != node:
			return

	if _target_assignments.has(target):
		_target_assignments.erase(target)

## get the node currently targeting a specific target
func get_target_owner(target: Node) -> Node:
	if _target_assignments.has(target):
		return _target_assignments[target]
	return null

## check if a target is available (not assigned to anyone)
func is_target_available(target: Node) -> bool:
	return not _target_assignments.has(target)

## called automatically when a target is destroyed
func _on_target_destroyed(target: Node, target_types: Array[String]) -> void:
	unregister_target(target, target_types)

## called automatically when a node is destroyed
func _on_node_destroyed(target: Node, node: Node) -> void:
	if is_instance_valid(target):
		release_target(target, node)

## debug: Get statistics about the manager state
func get_debug_info() -> Dictionary:
	var info = {
		"total_targets": 0,
		"total_assignments": _target_assignments.size(),
		"targets_by_type": {}
	}

	for type in _targets_by_type.keys():
		var count = _targets_by_type[type].size()
		info["targets_by_type"][type] = count
		info["total_targets"] += count

	return info

## debug: Print current state to console
func print_debug_info() -> void:
	var info = get_debug_info()
	print("=== TargetManager Debug Info ===")
	print("Total targets: ", info["total_targets"])
	print("Total assignments: ", info["total_assignments"])
	print("Targets by type:")
	for type in info["targets_by_type"]:
		print("  ", type, ": ", info["targets_by_type"][type])
