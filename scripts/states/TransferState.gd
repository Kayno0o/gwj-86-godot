class_name TransferState extends State

func init(p_parent: Entity) -> void:
	type = State.Type.Transfer
	super.init(p_parent)

func enter() -> void:
	var target: Totem = TargetManager.get_nearest_available_target(parent.global_position, [Enum.TargetType.Totem], parent)

	if not target:
		parent.current_target = null
		return

	pass

func process(_delta: float):
	if not parent.current_target or not is_instance_valid(parent.current_target):
		return State.Type.Idle
