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

	pass

func exit() -> void:
	pass

func move_to_target() -> void:
	var direction = (totem.global_position - parent.global_position).normalized()
	parent.velocity = direction * parent.get_movement_speed()
	parent.move_and_slide()

func _on_tween_finished():
	InventoryManager.sacrifice_mask(parent)
	parent.queue_free()
