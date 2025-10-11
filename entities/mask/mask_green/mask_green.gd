extends Mask

func on_ready():
	check_timer.timeout.connect(_on_check_timer_timeout)
	damage_timer.timeout.connect(_on_damage_timer_timeout)

	find_target()

func on_physics_process(_delta) -> void:
	if current_target:
		move_to_target()

func _on_check_timer_timeout():
	find_target()

func _on_damage_timer_timeout():
	if current_target == null or not is_instance_valid(current_target):
		return

	if current_target is not ResourceProps:
		return

	var distance = global_position.distance_to(current_target.global_position)
	if distance < pickup_distance:
		var health_comp: HealthComponent = Utils.get_component(current_target, HealthComponent)
		if health_comp:
			health_comp.on_damage(attack)

		return

	damage_timer.stop()

func find_target():
	var targets = get_tree().get_nodes_in_group("trees")
	var items = get_tree().get_nodes_in_group("items")

	targets.append_array(items)

	var valid_current = current_target if is_instance_valid(current_target) else null
	current_target = Utils.get_nearest(targets, valid_current, self)

	if check_timer.is_stopped():
		check_timer.start(check_cooldown)

func on_check_distance(distance: float) -> bool:
	if current_target is Item and distance < pickup_distance:
		velocity = Vector2.ZERO
		on_touch_item()
		return true
	
	if current_target is ResourceProps and distance < attack_distance:
		velocity = Vector2.ZERO
		on_touch_resource()
		return true

	return false

func on_touch_item():
	current_target.queue_free()
	current_target = null

func on_touch_resource():
	if damage_timer.is_stopped():
		damage_timer.start(attack_speed)
