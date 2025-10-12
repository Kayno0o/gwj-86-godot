extends State

## Attacking state - entity is attacking an enemy
## Periodically damages the enemy until it's destroyed

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

	# Check if target is still an enemy
	if not _is_enemy(entity.current_target):
		return "IdleState"

	# Check if we're still in range
	var distance = entity.global_position.distance_to(entity.current_target.global_position)
	if distance > entity.get_attack_range():
		# Target moved out of range, go back to moving
		return "MovingToTargetState"

	return ""

func _on_damage_timeout() -> void:
	if not entity.current_target or not is_instance_valid(entity.current_target):
		return

	if not _is_enemy(entity.current_target):
		return

	# Deal damage to the enemy
	var health_comp: HealthComponent = Utils.get_component(entity.current_target, HealthComponent)
	if not health_comp:
		return

	# Damage returns true if the target died
	if health_comp.on_damage(entity.get_attack()):
		# Enemy was destroyed, go back to idle to find new target
		damage_timer.stop()
		entity.current_target = null
		state_machine.change_state("IdleState")

func _is_enemy(target: Node) -> bool:
	# For now, check if target is a Mask with Enemy type
	# Later, you can add dedicated Enemy class
	if target is Mask:
		return target.type == Enum.EntityType.Enemy
	return false
