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
	if not parent.current_target or not is_instance_valid(parent.current_target) or not parent.current_target is Item:
		parent.current_target = null
		return

	# TODO: inventory logic, remove item desctruction
	TargetManager.release_target(parent.current_target, parent)
	parent.current_target.queue_free()
	parent.current_target = null
