class_name PickupState extends State

func init(p_parent: Entity) -> void:
	type = State.Type.Pickup

	super.init(p_parent)

func enter() -> void:
	parent.velocity = Vector2.ZERO
	pickup()

func process(_delta: float):
	return State.Type.Idle

func pickup() -> void:
	var item = parent.current_target
	if not item or not is_instance_valid(item) or not item is Item:
		parent.current_target = null
		return

	TargetManager.release_target(item, parent)
	TargetManager.unregister_target(item, TargetManager.get_target_types(item))
	parent.inventory_component.add_item(item)
	parent.current_target = null
