class_name SacrificeState extends State

var totem: Totem

func init(p_parent: Entity) -> void:
	type = State.Type.Sacrifice
	super.init(p_parent)

func enter() -> void:
	TargetManager.unregister_target(parent, [parent.target_type])

	totem = InventoryManager.totem

	# leave everything behind, be ready for SACRIFICE
	parent.inventory_component.drop_inventory()

	if not totem:
		_on_reached_totem()
		return

func exit() -> void:
	parent.velocity = Vector2.ZERO

func physics_process(_delta: float):
	if not totem:
		return
	
	if parent.global_position.distance_to(totem.global_position) <= parent.totem_approach_distance:
		_on_reached_totem()
		return

	move_to_target()

func move_to_target() -> void:
	var direction = (totem.global_position - parent.global_position).normalized()
	parent.velocity = direction * parent.get_movement_speed() * 2
	parent.move_and_slide()

func _on_reached_totem():
	if InventoryManager.sacrifice_mask_to_fire(parent):
		parent.queue_free()
	else:
		# for some reason, sacrifice did not work, go back idle
		change_state_type(State.Type.Idle)
