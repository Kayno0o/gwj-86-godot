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

func reparent_without_moving(child: Node2D, parent: Node2D, target: Node2D) -> void:
	if parent.is_ancestor_of(child):
		parent.remove_child(child)

	target.add_child(child)

	child.position += parent.global_position - target.global_position

func dictionnary_from_entries(keys: Array, values: Array) -> Dictionary:
	var dict: Dictionary = {}

	for i in range(keys):
		var key = keys[i]
		var value = values[i]
		dict[key] = value

	return dict

func iSum(array: Array[int]) -> int:
	var total = 0

	for amount in array:
		total += amount

	return total

## return empty string if translation is not found
func t(key: String) -> String:
	var value = tr(key)
	if value == key: return ""
	return value
