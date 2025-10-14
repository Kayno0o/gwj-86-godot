class_name SacrificeState extends State

var totem: Totem

func init(p_parent: Entity) -> void:
	type = State.Type.Sacrifice
	super.init(p_parent)

	Enum.current_shopping_list.is_empty()

func enter() -> void:
	pass

func exit() -> void:
	pass
