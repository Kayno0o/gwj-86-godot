class_name SacrificeState extends State

var totem: Totem

func init(p_parent: Entity) -> void:
	type = State.Type.Sacrifice
	super.init(p_parent)

func enter() -> void:
	TargetManager.unregister_target(parent, [parent.target_type])

	totem = InventoryManager.totem

	var tween = get_tree().create_tween()
	tween.tween_property(parent, "global_position", totem.global_position, 2) \
		.set_trans(Tween.TRANS_SINE) \
		.set_ease(Tween.EASE_IN_OUT)

	tween.finished.connect(_on_tween_finished)

	parent.inventory_component.drop_inventory()

	pass

func exit() -> void:
	pass

func process(_delta: float):
	# TODO move to fire or move items from totem to fire, and then move to fire
	return

func move_to_target() -> void:
	var direction = (totem.global_position - parent.global_position).normalized()
	parent.velocity = direction * parent.get_movement_speed()
	parent.move_and_slide()

func _on_tween_finished():
	if InventoryManager.sacrifice_mask_to_fire(parent):
		parent.inventory_component.drop_inventory()
		parent.queue_free()
