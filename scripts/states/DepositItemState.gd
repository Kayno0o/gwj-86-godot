class_name DepositItemState extends State

var deposit_timer: Timer
var search_timer: Timer

var is_depositing: bool = false

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
	is_depositing = false

	if not parent.current_target or not TargetManager.target_has_type(parent.current_target, Enum.TargetType.Totem):
		var target = TargetManager.get_nearest_available_target(parent.global_position, [Enum.TargetType.Totem], parent)
		if target and TargetManager.assign_target(target, parent):
			parent.current_target = target
	
	if not parent.inventory_component.is_inventory_full():
		search_timer.start(parent.get_target_search_cooldown())

func exit() -> void:
	deposit_timer.stop()

func process(_delta: float):
	if not parent.current_target or \
		 not is_instance_valid(parent.current_target) or \
		 parent.inventory_component.is_empty():
		parent.current_target = null
		return State.Type.Idle
	
	if not TargetManager.target_has_type(parent.current_target, Enum.TargetType.Totem):
		return State.Type.MoveToTarget

	var distance = parent.global_position.distance_to(parent.current_target.global_position)

	if distance < parent.totem_approach_distance:
		if not is_depositing:
			parent.velocity = Vector2.ZERO
			is_depositing = true
			deposit_timer.start(parent.deposit_speed)
	else:
		is_depositing = false
		deposit_timer.stop()
		move_to_totem()

	return null

func move_to_totem() -> void:
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

func _on_search_timeout() -> void:
	search_target()
	search_timer.start(parent.get_target_search_cooldown())

func _on_deposit_timeout():
	if not parent.current_target or not is_instance_valid(parent.current_target):
		parent.current_target = null
		return

	# TODO deposit to totem
	var item = parent.inventory_component.pop_item()
	parent.current_target.deposit_item(Enum.ItemType.find_key(item.item_type), 1)

	if not parent.inventory_component.is_empty():
		deposit_timer.start(parent.deposit_speed)
