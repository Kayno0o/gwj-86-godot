extends Node

func get_nearest(targets: Array, current_target: Node, node: Node) -> Node:
	if targets.is_empty():
		return

	var nearest_target = null
	var nearest_target_comp: TargetComponent = null
	var nearest_distance = INF

	for target in targets:
		if not is_instance_valid(target):
			continue

		var target_comp: TargetComponent = Utils.get_component(target, TargetComponent)
		if not target_comp:
			continue

		if not target_comp.can_target() and target != current_target:
			continue

		var distance = node.global_position.distance_to(target.global_position)
		if distance < nearest_distance:
			nearest_distance = distance
			nearest_target = target
			nearest_target_comp = target_comp

	if nearest_target:
		var current_target_comp: TargetComponent = Utils.get_component(current_target, TargetComponent)
		if current_target_comp and current_target_comp:
			current_target_comp.stop_targetting()

		nearest_target_comp.target(node)

		return nearest_target

	return null

func get_component(node: Node, component_type) -> Node:
	if not node or not is_instance_valid(node):
		return null

	# First check direct children
	for child in node.get_children():
		if is_instance_of(child, component_type):
			return child

	# Then search recursively in nested children
	for child in node.get_children():
		var found = get_component(child, component_type)
		if found:
			return found

	return null

func has_component(node: Node, component_type) -> bool:
	return get_component(node, component_type) != null
