extends State

## Idle state - entity is waiting for a target
## Searches for targets periodically based on entity's behavior profile

var search_timer: Timer = null
var has_searched_once: bool = false

func _ready() -> void:
	# Create search timer when state is ready
	search_timer = Timer.new()
	search_timer.one_shot = false
	search_timer.timeout.connect(_on_search_timeout)
	add_child(search_timer)

func enter() -> void:
	# Stop movement
	if entity:
		entity.velocity = Vector2.ZERO

	# Start searching for targets
	if not has_searched_once:
		_search_for_target()
		has_searched_once = true

	if search_timer:
		search_timer.start(entity.get_target_search_cooldown())

func exit() -> void:
	if search_timer and not search_timer.is_stopped():
		search_timer.stop()

func update(_delta: float) -> String:
	# If we found a target, transition to moving state
	if entity.current_target != null and is_instance_valid(entity.current_target):
		return "MovingToTargetState"

	return ""

func _on_search_timeout() -> void:
	_search_for_target()

func _search_for_target() -> void:
	if not entity:
		return

	# Release current target if it exists
	if entity.current_target and is_instance_valid(entity.current_target):
		TargetManager.release_target(entity.current_target, entity)
		entity.current_target = null

	# Get behavior profile for this entity type
	var priorities = Enum.get_target_priorities(entity.type)

	# Search for targets in priority order
	var new_target = _find_target_by_priority(priorities)

	if new_target and TargetManager.assign_target(new_target, entity):
		entity.current_target = new_target

func _find_target_by_priority(priorities: Dictionary) -> Node:
	# Try primary targets first
	var target = _find_nearest_target(priorities["primary_targets"])
	if target:
		return target

	# Try secondary targets
	target = _find_nearest_target(priorities["secondary_targets"])
	if target:
		return target

	# Try tertiary targets
	target = _find_nearest_target(priorities["tertiary_targets"])
	if target:
		return target

	return null

func _find_nearest_target(target_types: Array) -> Node:
	if target_types.size() == 0:
		return null

	# Convert to typed array
	var typed_targets: Array[String] = []
	for t in target_types:
		typed_targets.append(t)

	return TargetManager.get_nearest_available_target(
		entity.global_position,
		typed_targets,
		entity
	)
