extends Node

# new target becomes available
signal target_available(target: Node2D, target_types: Array[Enum.TargetType])

# target is destroyed/removed
signal target_removed(target: Node2D)

# dictionary to store targets by type
var targets: Dictionary[Enum.TargetType, Array] = {}

# dictionary to track which node is targeting which object
# format: { target: targeter }
var assigned_targets: Dictionary[Node, Node] = {}

func init() -> void:
	targets = {}
	assigned_targets = {}

func register_target(target: Node2D, target_types: Array[Enum.TargetType]) -> void:
	if not is_instance_valid(target):
		return

	# add to each type category
	for type in target_types:
		if not targets.has(type):
			targets[type] = []

		if target not in targets[type]:
			targets[type].append(target)

	# emit signal so interested nodes can react
	target_available.emit(target, target_types)

	# connect to the target's tree_exiting signal to auto-unregister
	if not target.tree_exiting.is_connected(_on_target_destroyed):
		target.tree_exiting.connect(_on_target_destroyed.bind(target, target_types))

## unregister a target (called automatically on destruction)
func unregister_target(target: Node2D, target_types: Array[Enum.TargetType]) -> void:
	if not is_instance_valid(target):
		return

	# remove from all type categories
	for type in target_types:
		if targets.has(type) and target in targets[type]:
			targets[type].erase(target)

	# clear assignment if this target was being targeted
	if assigned_targets.has(target):
		assigned_targets.erase(target)

	target_removed.emit(target)

## get all targets of specific types
func get_targets_of_type(target_types: Array[Enum.TargetType]) -> Array[Node2D]:
	var results: Array[Node2D] = []
	# used to deduplicate (as a single node can have multiple target type)
	var seen: Dictionary[Node, bool] = {}

	for type in target_types:
		if targets.has(type):
			for target in targets[type]:
				if not seen.has(target):
					results.append(target)
					seen[target] = true

	return results

## get the nearest available target to a position
func get_nearest_available_target(
	current_position: Vector2,
	target_types: Array[Enum.TargetType],
	requester: Node2D,
) -> Node2D:
	var candidates = get_targets_of_type(target_types)
	var nearest: Node2D = null
	var nearest_distance: float = INF

	for candidate in candidates:
		if not is_instance_valid(candidate):
			cleanup_invalid_target(candidate)
			continue

		# check if target is already assigned to another node
		if assigned_targets.has(candidate):
			# validate the assigned node still exists
			var assigned_node = assigned_targets[candidate]
			if not is_instance_valid(assigned_node):
				# node no longer exists, release the target
				assigned_targets.erase(candidate)
			elif assigned_node != requester:
				# target is assigned to a different valid node
				continue

		var distance = current_position.distance_to(candidate.global_position)
		if distance < nearest_distance:
			nearest = candidate
			nearest_distance = distance

	return nearest

## internal: Clean up an invalid target from all tracking dictionaries
func cleanup_invalid_target(target: Node2D) -> void:
	# remove from targets
	for type in targets.keys():
		if target in targets[type]:
			targets[type].erase(target)

	# remove from assignments
	if assigned_targets.has(target):
		assigned_targets.erase(target)

## assign a node to a target (updates tracking)
func start_targeting(target: Node2D, node: Node2D) -> bool:
	if not is_instance_valid(target) or not is_instance_valid(node):
		return false

	# skip assignment tracking, totems can be targeted by multiple nodes
	if target_has_types(target, [Enum.TargetType.Totem, Enum.TargetType.Villain, Enum.TargetType.Mask]):
		return true

	# check if already assigned to another node
	if assigned_targets.has(target) and assigned_targets[target] != node:
		return false

	assigned_targets[target] = node

	# connect to node's tree_exiting signal to auto-release target when node is destroyed
	if not node.tree_exiting.is_connected(_on_node_destroyed):
		node.tree_exiting.connect(_on_node_destroyed.bind(target, node))

	return true

## release a target assignment (optionally specify which node to release from)
func stop_targeting(target: Node2D, node: Node2D) -> bool:
	if not is_instance_valid(target):
		return false

	if assigned_targets.get(target) != node:
		return false

	assigned_targets.erase(target)

	return true

## get the node currently targeting a specific target
func get_target_owner(target: Node2D) -> Node2D:
	if assigned_targets.has(target):
		return assigned_targets[target]
	return null

## check if a target is available (not assigned to anyone)
func is_target_available(target: Node2D) -> bool:
	return not assigned_targets.has(target)

## called automatically when a target is destroyed
func _on_target_destroyed(target, target_types: Array[Enum.TargetType]) -> void:
	unregister_target(target, target_types)

## called automatically when a node is destroyed
func _on_node_destroyed(target, node) -> void:
	if target and is_instance_valid(target):
		stop_targeting(target, node)

func get_target_types(target: Node) -> Array[Enum.TargetType]:
	if not is_instance_valid(target):
		return []

	if target.get("target_types") != null:
		var types = target.get("target_types")
		if types is Array:
			return types

	if target.get("target_type") != null:
		return [target.get("target_type")]

	return []

func target_has_type(target: Node, type: Enum.TargetType) -> bool:
	return type in get_target_types(target)

func target_has_types(target: Node, types: Array[Enum.TargetType]) -> bool:
	for type in types:
		if type in get_target_types(target):
			return true

	return false
