extends Node

func get_component(node: Node, component_type: Component.Type) -> Node:
	if not node or not is_instance_valid(node):
		return null

	# Check if node has a components dictionary
	if "components" in node and node.components is Dictionary:
		if node.components.has(component_type):
			return node.components[component_type]

	# first check direct children
	for child in node.get_children():
		if child is Component and child.type == component_type:
			return child

	# then search recursively in nested children
	for child in node.get_children():
		var found = get_component(child, component_type)
		if found:
			return found

	return null

func has_component(node: Node, component_type) -> bool:
	return get_component(node, component_type) != null
