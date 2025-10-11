extends Node

func get_nearest(targets: Array, current: Node, global_position: Vector2) -> Node:
	if targets.is_empty():
		return

	var nearest_target = null
	var nearest_distance = INF

	for target in targets:
		if not is_instance_valid(target):
			continue

		if target.is_targeted && target != current:
			continue

		var distance = global_position.distance_to(target.global_position)
		if distance < nearest_distance:
			nearest_distance = distance
			nearest_target = target

	if nearest_target:
		if current and is_instance_valid(current):
			current.is_targeted = false
		nearest_target.is_targeted = true

		return nearest_target

	return null
