class_name TransferState extends State

var totem: Node2D
var fire: Node2D

func init(p_parent: Entity) -> void:
	type = State.Type.Transfer
	super.init(p_parent)

func enter() -> void:
	totem = InventoryManager.totem
	fire = InventoryManager.fire

	if not totem or not fire:
		change_state_type(State.Type.Idle)
		return

func exit() -> void:
	parent.current_target = null
	parent.velocity = Vector2.ZERO
