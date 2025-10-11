extends Mask

var target: ResourceNode = null

func abstract_ready():
	check_timer.timeout.connect(_on_check_timer_timeout)
	damage_timer.timeout.connect(_on_damage_timer_timeout)

	find_target()

func abstract_physics_process(_delta) -> void:
	if target:
		move_to_target()

func _on_check_timer_timeout():
	find_target()

func _on_damage_timer_timeout():
	if target and is_instance_valid(target):
		var distance = global_position.distance_to(target.global_position)
		if distance < 30.0:
			target.on_damage(attack)
		else:
			damage_timer.stop()

func find_target():
	var trees = get_tree().get_nodes_in_group("trees")
	if trees.is_empty():
		return

	var nearest_tree = null
	var nearest_distance = INF

	for tree in trees:
		if tree.is_targeted:
			continue

		var distance = global_position.distance_to(tree.global_position)
		if distance < nearest_distance:
			nearest_distance = distance
			nearest_tree = tree

	if nearest_tree:
		if target:
			target.is_targeted = false

		target = nearest_tree
		target.is_targeted = true
	
	if check_timer.is_stopped():
		check_timer.start(check_cooldown)

func move_to_target():
	if not target or not is_instance_valid(target):
		target = null
		find_target()
		return

	var direction = (target.global_position - global_position).normalized()
	var distance = global_position.distance_to(target.global_position)

	if distance < 30.0:
		velocity = Vector2.ZERO
		if damage_timer.is_stopped():
			damage_timer.start(attack_speed)
		return

	velocity = direction * movement_speed
	move_and_slide()
