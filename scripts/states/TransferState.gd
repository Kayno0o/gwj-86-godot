class_name TransferState extends State

var totem: Node2D
var fire: Node2D

var on_arrival: Callable

func init(p_parent: Entity) -> void:
	type = State.Type.Transfer
	super.init(p_parent)

func enter() -> void:
	totem = InventoryManager.totem
	fire = InventoryManager.fire

	if not totem or not fire:
		change_state_type(State.Type.Idle)
		return

	_go_to_target(totem, _on_totem_arrival)

func exit() -> void:
	parent.current_target = null
	parent.velocity = Vector2.ZERO

func process(_delta: float):
	if not parent.current_target or not is_instance_valid(parent.current_target):
		change_state_type(State.Type.Idle)
		return null

	var distance = parent.global_position.distance_to(parent.current_target.global_position)
	if distance < parent.totem_approach_distance:
		on_arrival.call()
	else:
		var direction = (parent.current_target.global_position - parent.global_position).normalized()
		parent.velocity = direction * parent.get_movement_speed()
		parent.move_and_slide()

	return null

func _go_to_target(target: Node2D, p_on_arrival: Callable):
	parent.current_target = target
	on_arrival = p_on_arrival

func _on_totem_arrival():
	_go_to_target(fire, _on_fire_arrival)

func _on_fire_arrival():
	var pending_item_type = InventoryManager.get_next_pending_item()
	if pending_item_type:
		InventoryManager.complete_pending_item(pending_item_type)

	if InventoryManager.has_pending_items():
		_go_to_target(totem, _on_totem_arrival)
	else:
		change_state_type(State.Type.Idle)
