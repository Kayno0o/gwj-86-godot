class_name MoveToTargetState extends State

var search_timer: Timer

func init(p_parent: Entity) -> void:
	type = State.Type.MoveToTarget

	super.init(p_parent)

	search_timer = Timer.new()
	search_timer.one_shot = true
	search_timer.timeout.connect(_on_search_timeout)
	add_child(search_timer)

func enter() -> void:
	search_timer.start(parent.get_target_search_cooldown())

func exit() -> void:
	search_timer.stop()
	
func process(_delta: float):
	if not parent.current_target or not is_instance_valid(parent.current_target):
		parent.current_target = null
		return State.Type.Idle

	var distance = parent.global_position.distance_to(parent.current_target.global_position)

	if can_interact(distance):
		return get_interaction_state()

	move_to_target()
	return null

func _on_search_timeout() -> void:
	search_target()
	search_timer.start(parent.get_target_search_cooldown())

func can_interact(distance: float) -> bool:
	var target = parent.current_target
	if not target or not is_instance_valid(target):
		return false

	if parent.type == Enum.EntityType.MaskTank and TargetManager.target_has_type(target, Enum.TargetType.Totem):
		return distance < parent.totem_approach_distance

	if target is Item:
		return distance < parent.get_pickup_range()

	if Utils.has_component(target, Component.Type.Health):
		return distance < parent.get_attack_range()

	return false

func move_to_target() -> void:
	if not parent.current_target or not is_instance_valid(parent.current_target):
		return

	var direction = (parent.current_target.global_position - parent.global_position).normalized()
	parent.velocity = direction * parent.get_movement_speed()
	parent.move_and_slide()

func search_target() -> void:
	var new_target = parent.find_target()

	if new_target:
		if parent.current_target:
			TargetManager.release_target(parent.current_target, parent)

		if not TargetManager.assign_target(new_target, parent):
			return

		parent.current_target = new_target

func get_interaction_state():
	var target = parent.current_target
	if not target or not is_instance_valid(target):
		return null

	if parent.type == Enum.EntityType.MaskTank and TargetManager.target_has_type(target, Enum.TargetType.Totem):
		return State.Type.Idle

	if target is Item:
		return State.Type.Pickup

	if Utils.has_component(target, Component.Type.Health):
		return State.Type.Attack

	return State.Type.Idle
