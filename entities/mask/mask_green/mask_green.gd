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
	if current_target and is_instance_valid(current_target):
		var distance = global_position.distance_to(current_target.global_position)
		if distance < pickup_distance:
			current_target.on_damage(attack)
		else:
			damage_timer.stop()

func find_target():
	var targets = get_tree().get_nodes_in_group("trees")
	var items = get_tree().get_nodes_in_group("items")

	targets.append_array(items)

	find_nearest(targets)
	
	if check_timer.is_stopped():
		check_timer.start(check_cooldown)

func on_pickup():
	if is_instance_of(current_target, Item):
		current_target.queue_free()
		current_target = null
		return

	if is_instance_of(current_target, ResourceProps):
		if damage_timer.is_stopped():
			damage_timer.start(attack_speed)
