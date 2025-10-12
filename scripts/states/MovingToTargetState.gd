extends State

## Moving to target state - entity is moving towards its current target
## Determines which interaction state to transition to based on target type and distance

func enter() -> void:
	pass

func exit() -> void:
	if entity:
		entity.velocity = Vector2.ZERO

func update(_delta: float) -> String:
	# If target is invalid or gone, return to idle
	if not entity.current_target or not is_instance_valid(entity.current_target):
		entity.current_target = null
		return "IdleState"

	# Calculate distance to target
	var distance = entity.global_position.distance_to(entity.current_target.global_position)

	# Check for higher priority targets (e.g., gatherer spots enemy in range)
	var higher_priority_target = _check_for_higher_priority_target()
	if higher_priority_target:
		# Release current target and switch to higher priority one
		TargetManager.release_target(entity.current_target, entity)
		if TargetManager.assign_target(higher_priority_target, entity):
			entity.current_target = higher_priority_target
			# Continue moving to the new target
			_move_to_target()
			return ""

	# Check if we're close enough to interact with target
	if _is_in_interaction_range(distance):
		return _determine_interaction_state()

	# Keep moving towards target
	_move_to_target()

	return ""

func _move_to_target() -> void:
	if not entity or not entity.current_target:
		return

	var direction = (entity.current_target.global_position - entity.global_position).normalized()
	entity.velocity = direction * entity.get_movement_speed()
	entity.move_and_slide()

func _is_in_interaction_range(distance: float) -> bool:
	if not entity.current_target:
		return false

	# Items use pickup range
	if entity.current_target is Item:
		return distance < entity.get_pickup_range()

	# Resources and enemies use attack range
	if entity.current_target is ResourceProps or _is_enemy(entity.current_target):
		return distance < entity.get_attack_range()

	return false

func _determine_interaction_state() -> String:
	if not entity.current_target:
		return "IdleState"

	# Item -> Pick up
	if entity.current_target is Item:
		return "PickingUpState"

	# Resource -> Gather
	if entity.current_target is ResourceProps:
		return "GatheringState"

	# Enemy -> Attack
	if _is_enemy(entity.current_target):
		return "AttackingState"

	return "IdleState"

func _is_enemy(target: Node) -> bool:
	# Check if target is an enemy mask
	if target is Mask:
		return target.type == Enum.EntityType.Enemy
	return false

func _check_for_higher_priority_target() -> Node:
	# Get behavior profile for this entity type
	var priorities = Enum.get_target_priorities(entity.type)

	# Determine current target priority level
	var current_priority = _get_target_priority_level(entity.current_target, priorities)

	# Only check for higher priority targets
	if current_priority == 0:  # Already at highest priority
		return null

	# Check primary targets if we're on secondary or tertiary
	if current_priority >= 1:
		var target = _find_target_in_range(priorities["primary_targets"], entity.get_attack_view_distance())
		if target:
			return target

	# Check secondary targets if we're on tertiary
	if current_priority >= 2:
		var target = _find_target_in_range(priorities["secondary_targets"], entity.get_attack_view_distance())
		if target:
			return target

	return null

func _get_target_priority_level(target: Node, priorities: Dictionary) -> int:
	# Returns 0 for primary, 1 for secondary, 2 for tertiary, -1 for none
	var target_types = _get_target_types(target)

	for target_type in target_types:
		if target_type in priorities["primary_targets"]:
			return 0
		if target_type in priorities["secondary_targets"]:
			return 1
		if target_type in priorities["tertiary_targets"]:
			return 2

	return -1

func _get_target_types(target: Node) -> Array[String]:
	var types: Array[String] = []

	if target is Item:
		types.append("item")
	elif target is ResourceProps:
		# Resources can be trees, rocks, etc.
		if target.target_types.size() > 0:
			types.append_array(target.target_types)
	elif target is Mask:
		if target.type == Enum.EntityType.Enemy:
			types.append("enemy")
		else:
			types.append("mask")

	return types

func _find_target_in_range(target_types: Array, target_range: float) -> Node:
	if target_types.size() == 0:
		return null

	# Convert to typed array
	var typed_targets: Array[String] = []
	for t in target_types:
		typed_targets.append(t)

	var candidates = TargetManager.get_targets_of_type(typed_targets)

	for candidate in candidates:
		if not is_instance_valid(candidate):
			continue

		var distance = entity.global_position.distance_to(candidate.global_position)
		if distance <= target_range:
			# Check if available
			if TargetManager.is_target_available(candidate) or TargetManager.get_target_owner(candidate) == entity:
				return candidate

	return null
