class_name DepositItemState extends State

var deposit_timer: Timer
var search_timer: Timer

enum SubState { MOVING_TO_TOTEM, DEPOSITING }
var sub_state: SubState

func init(p_parent: Entity) -> void:
	type = State.Type.DepositItem

	super.init(p_parent)

	deposit_timer = Timer.new()
	deposit_timer.one_shot = true
	deposit_timer.timeout.connect(_on_deposit_timeout)
	add_child(deposit_timer)

	search_timer = Timer.new()
	search_timer.one_shot = true
	search_timer.timeout.connect(_on_search_timeout)
	add_child(search_timer)

func enter() -> void:
	sub_state = SubState.MOVING_TO_TOTEM

	if not parent.current_target or not TargetManager.target_has_type(parent.current_target, Enum.TargetType.Totem):
		var target = TargetManager.get_nearest_available_target(parent.global_position, [Enum.TargetType.Totem], parent)
		if target and TargetManager.start_targeting(target, parent):
			parent.current_target = target

	if not parent.inventory_component.is_inventory_full():
		search_timer.start(parent.get_target_search_cooldown())

func exit() -> void:
	deposit_timer.stop()
	search_timer.stop()

func process(_delta: float):
	if not parent.current_target or not is_instance_valid(parent.current_target) \
	or parent.inventory_component.is_empty():
		parent.current_target = null
		return State.Type.Idle

	# if current target is not totem, we should not be in deposit state
	if not TargetManager.target_has_type(parent.current_target, Enum.TargetType.Totem):
		return State.Type.MoveToTarget

	match sub_state:
		SubState.MOVING_TO_TOTEM:
			move_to_totem()
		SubState.DEPOSITING:
			depositing()
	
	return null

func move_to_totem():
	var distance = parent.global_position.distance_to(parent.current_target.global_position)

	if distance < parent.totem_approach_distance:
		sub_state = SubState.DEPOSITING
		parent.velocity = Vector2.ZERO
		deposit_timer.start(parent.deposit_speed)
	else:
		var direction = (parent.current_target.global_position - parent.global_position).normalized()
		parent.velocity = direction * parent.get_movement_speed()
		parent.move_and_slide()

func depositing():
	if deposit_timer.is_stopped():
		deposit_timer.start(parent.deposit_speed)

func search_target() -> void:
	var new_target = parent.find_closer_target()

	if not new_target:
		return

func _on_search_timeout() -> void:
	search_target()
	search_timer.start(parent.get_target_search_cooldown())

func _on_deposit_timeout():
	if not parent.current_target or not is_instance_valid(parent.current_target) \
	or parent.inventory_component.is_empty():
		parent.current_target = null
		change_state_type(State.Type.Idle)
		return

	var item = parent.inventory_component.pop_item()
	Utils.reparent_without_moving(item, parent, parent.current_target)

	item.fly_to(parent.current_target.global_position)

	InventoryManager.deposit_item(Enum.ItemType.find_key(item.item_type), 1)

	if not parent.inventory_component.is_empty():
		deposit_timer.start(parent.deposit_speed)
	else:
		change_state_type(State.Type.Idle)
