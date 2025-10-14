extends Node

func get_component(node: Node, component_type: Component.Type) -> Component:
	if not node or not is_instance_valid(node):
		return null

	# Check if node has a components dictionary
	if "components" in node and node.components is Dictionary:
		if node.components.has(component_type):
			return node.components[component_type]

	return null

func has_component(node: Node, component_type: Component.Type) -> bool:
	return get_component(node, component_type) != null
