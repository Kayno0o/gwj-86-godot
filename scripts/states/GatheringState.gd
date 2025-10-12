extends State

## Gathering state - entity is attacking a resource to gather it
## Periodically damages the resource until it's destroyed

var damage_timer: Timer = null

func enter() -> void:
	# Stop movement
	if entity:
		entity.velocity = Vector2.ZERO

	# Use the entity's existing damage timer
	if entity.damage_timer:
		damage_timer = entity.damage_timer
		if not damage_timer.timeout.is_connected(_on_damage_timeout):
			damage_timer.timeout.connect(_on_damage_timeout)
		damage_timer.start(entity.get_attack_speed())

func exit() -> void:
	if damage_timer and not damage_timer.is_stopped():
		damage_timer.stop()

func update(_delta: float) -> String:
	# Check if target is still valid
	if not entity.current_target or not is_instance_valid(entity.current_target):
		entity.current_target = null
		return "IdleState"

	# Check if target is still a resource
	if not entity.current_target is ResourceProps:
		return "IdleState"

	# Check for higher priority targets (e.g., enemy comes into range)
	var higher_priority_target = _check_for_enemy_in_range()
	if higher_priority_target:
		# Release current target and switch to enemy
		TargetManager.release_target(entity.current_target, entity)
		if TargetManager.assign_target(higher_priority_target, entity):
			entity.current_target = higher_priority_target
			return "MovingToTargetState"

	# Check if we're still in range
	var distance = entity.global_position.distance_to(entity.current_target.global_position)
	if distance > entity.get_attack_range():
		# Target moved out of range, go back to moving
		return "MovingToTargetState"

	return ""

func _on_damage_timeout() -> void:
	if not entity.current_target or not is_instance_valid(entity.current_target):
		return

	if not entity.current_target is ResourceProps:
		return

	# Deal damage to the resource
	var health_comp: HealthComponent = Utils.get_component(entity.current_target, HealthComponent)
	if not health_comp:
		return

	# Damage returns true if the target died
	if health_comp.on_damage(entity.get_attack()):
		# Resource was destroyed, go back to idle to find new target
		damage_timer.stop()
		entity.current_target = null
		state_machine.change_state("IdleState")

func _check_for_enemy_in_range() -> Node:
	# Only check for enemies if this entity type has enemies as secondary targets
	var priorities = Enum.get_target_priorities(entity.type)

	# Gatherers have enemies as secondary targets
	if "enemy" not in priorities["secondary_targets"]:
		return null

	# Look for enemies in attack view distance
	var enemy_types: Array[String] = ["enemy"]
	var enemies = TargetManager.get_targets_of_type(enemy_types)

	for enemy in enemies:
		if not is_instance_valid(enemy):
			continue

		var distance = entity.global_position.distance_to(enemy.global_position)
		if distance <= entity.get_attack_view_distance():
			# Check if available
			if TargetManager.is_target_available(enemy) or TargetManager.get_target_owner(enemy) == entity:
				return enemy

	return null
