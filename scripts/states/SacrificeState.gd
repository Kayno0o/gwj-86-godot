class_name SacrificeState extends State

var totem: Totem

func init(p_parent: Entity) -> void:
	type = State.Type.Sacrifice
	super.init(p_parent)

func enter() -> void:
	TargetManager.unregister_target(parent, [parent.target_type])
	pass

func exit() -> void:
	pass
