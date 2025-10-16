class_name TransferState extends State

var deposit_timer: Timer

var totem: Totem
var fire: Fire

var destination: Node2D

enum SubState { DEPOSITING, COLLECTING }
var sub_state = SubState.DEPOSITING

func init(p_parent: Entity) -> void:
	type = State.Type.Transfer

	super.init(p_parent)

	deposit_timer = Timer.new()
	deposit_timer.one_shot = true
	deposit_timer.timeout.connect(_on_deposit_timeout)
	add_child(deposit_timer)

func enter() -> void:
	totem = InventoryManager.totem
	fire = InventoryManager.fire

	if not totem or not fire:
		change_state_type(State.Type.Idle)
		return

	InventoryManager.current_mask_transfering.push_back(parent)
	
	# always start by depositing current inventory to totem first
	if not parent.inventory_component.is_empty():
		sub_state = SubState.DEPOSITING
		destination = totem
	else:
		# if inventory is empty, start collecting from totem
		sub_state = SubState.COLLECTING
		destination = totem

func exit() -> void:
	parent.current_target = null
	parent.velocity = Vector2.ZERO

	InventoryManager.remove_mask_transfering(parent)

	deposit_timer.stop()

func physics_process(_delta: float):
	if not destination:
		return State.Type.Idle

	if parent.global_position.distance_to(destination.global_position) > parent.totem_approach_distance:
		move_to_destination()
		return

	# reached destination
	_start_depositing()

func move_to_destination():
	var direction = (destination.global_position - parent.global_position).normalized()
	parent.velocity = direction * parent.get_movement_speed()
	parent.move_and_slide()

func invert_destination():
	if destination == totem:
		destination = fire
		return

	destination = totem

func _should_exit_transfer_state() -> bool:
	return parent.inventory_component.is_empty() and not InventoryManager.has_items_to_transfer()

func _start_depositing():
	if deposit_timer.is_stopped():
		deposit_timer.start(parent.deposit_speed)

func _on_deposit_timeout():
	if sub_state == SubState.DEPOSITING:
		_handle_deposit_tick()
		return

	_handle_collect_tick()

func _handle_deposit_tick():
	if parent.inventory_component.is_empty():
		if _should_exit_transfer_state():
			change_state_type(State.Type.Idle)
			return

		sub_state = SubState.COLLECTING
		destination = totem
		return

	var item = parent.inventory_component.pop_item()

	# safely deposit to totem
	if destination == totem:
		Utils.reparent_without_moving(item, parent, destination)
		item.fly_to(destination.global_position)

		InventoryManager.deposit_item_to_inventory(Enum.ItemType.find_key(item.item_type), 1)
		deposit_timer.start(parent.deposit_speed)

		return

	# item could not be sacrificed to fire, go deposit to totem
	if not InventoryManager.sacrifice_item_to_fire(Enum.ItemType.find_key(item.item_type), 1, parent):
		parent.inventory_component.add_item(item)

		sub_state = SubState.DEPOSITING
		destination = totem

		return

	Utils.reparent_without_moving(item, parent, destination)
	item.fly_to(destination.global_position)

	deposit_timer.start(parent.deposit_speed)

func _handle_collect_tick():
	if _should_exit_transfer_state():
		change_state_type(State.Type.Idle)
		return

	if parent.inventory_component.is_inventory_full() or not InventoryManager.has_items_to_transfer():
		destination = fire
		sub_state = SubState.DEPOSITING
		return

	var item_type_key = InventoryManager.get_item_type_to_transfer(parent)
	# should not append since we're checking has_items_to_transfer before
	if not item_type_key:
		change_state_type(State.Type.Idle)
		return

	var item_scene: PackedScene = InventoryManager.get_item_scene_from_item_type(item_type_key)
	if item_scene:
		var item: Item = item_scene.instantiate()
		totem.add_child(item)
		item.global_position = totem.global_position

		parent.inventory_component.add_item(item)
		deposit_timer.start(parent.deposit_speed)

		InventoryManager.get_from_inventory(item_type_key)

		return

	push_error("Scene for item type %s was not found" % [item_type_key])
	change_state_type(State.Type.Idle)
