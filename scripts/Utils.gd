extends Node

func get_component(node: Node, component_type) -> Node:
	if not node or not is_instance_valid(node):
		return null

	# first check direct children
	for child in node.get_children():
		if is_instance_of(child, component_type):
			return child

	# then search recursively in nested children
	for child in node.get_children():
		var found = get_component(child, component_type)
		if found:
			return found

	return null

func has_component(node: Node, component_type) -> bool:
	return get_component(node, component_type) != null
