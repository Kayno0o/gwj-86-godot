class_name IdleState extends State

var search_timer: Timer
var wandering_timer: Timer

var should_deposit: bool = false
var wandering_spot: Vector2 = Vector2.ZERO

func init(p_parent: Entity) -> void:
	type = State.Type.Idle
	super.init(p_parent)

	search_timer = Timer.new()
	search_timer.one_shot = true
	search_timer.timeout.connect(_on_search_timeout)
	add_child(search_timer)

	wandering_timer = Timer.new()
	wandering_timer.one_shot = true
	wandering_timer.timeout.connect(_on_wandering_timeout)
	add_child(wandering_timer)

func enter() -> void:
	search_timer.start(parent.get_target_search_cooldown())

	parent.velocity = Vector2.ZERO
	should_deposit = false

	wandering_spot = Vector2.ZERO

func exit() -> void:
	search_timer.stop()
	wandering_timer.stop()

func process(_delta):
	if parent.type == Enum.EntityType.MaskTransporter and InventoryManager.has_pending_items():
		return State.Type.Transfer

	# target found, move to it
	if parent.current_target and is_instance_valid(parent.current_target):
		return State.Type.MoveToTarget

	if should_deposit:
		return State.Type.DepositItem

	# nothing to do, then wander around
	if not wandering_spot.is_equal_approx(Vector2.ZERO):
		move_to_wandering_spot()

		return

	if wandering_timer.is_stopped():
		wandering_timer.start(randf_range(parent.wandering_cooldown, parent.wandering_cooldown * 2))

func search_target() -> void:
	var new_target = parent.find_closer_target()

	if new_target:
		if parent.current_target:
			TargetManager.stop_targeting(parent.current_target, parent)

		if not TargetManager.start_targeting(new_target, parent):
			return

		parent.current_target = new_target

		return

	# entity did not find any target, and has item in inventory, go deposit
	if not parent.current_target and not parent.inventory_component.is_empty():
		should_deposit = true

func move_to_wandering_spot() -> void:
	var direction = (wandering_spot - parent.global_position).normalized()
	parent.velocity = direction * parent.get_movement_speed() / 2
	parent.move_and_slide()

	if parent.global_position.distance_to(wandering_spot) < 4.0:
		parent.velocity = Vector2.ZERO
		wandering_spot = Vector2.ZERO

func _on_search_timeout() -> void:
	search_target()
	search_timer.start(parent.get_target_search_cooldown())

func _on_wandering_timeout() -> void:
	var offset = Vector2(
		randf_range(-parent.wandering_distance, parent.wandering_distance),
		randf_range(-parent.wandering_distance, parent.wandering_distance),
	)
	wandering_spot = parent.global_position + offset
