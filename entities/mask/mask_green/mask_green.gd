extends Mask

var target_search_timer: Timer

func _ready():
	# call parent _ready first to initialize timers
	super._ready()

	damage_timer.timeout.connect(_on_damage_timer_timeout)

	# subscribe to target availability events
	TargetManager.target_removed.connect(_on_target_removed)

	# create and start periodic target search timer
	target_search_timer = Timer.new()
	target_search_timer.one_shot = false
	target_search_timer.timeout.connect(_on_target_search_timer_timeout)
	add_child(target_search_timer)
	target_search_timer.start()

	# find initial target
	find_target()

func on_physics_process(_delta) -> void:
	if current_target:
		move_to_target()

func _on_damage_timer_timeout():
	if current_target == null or not is_instance_valid(current_target):
		return

	if current_target is not ResourceProps:
		return

	var distance = global_position.distance_to(current_target.global_position)
	if distance < pickup_distance:
		var health_comp: HealthComponent = Utils.get_component(current_target, HealthComponent)
		if not health_comp:
			return

		if health_comp.on_damage(attack):
			damage_timer.stop()
			target_search_timer.start(target_search_cooldown)

		return

	damage_timer.stop()

func _on_target_search_timer_timeout():
	find_target()

func find_target():
	if current_target and is_instance_valid(current_target):
		TargetManager.release_target(current_target, self)
		current_target = null

	var new_target = TargetManager.get_nearest_available_target(
		global_position,
		interested_target_types,
		self,
	)

	if not new_target:
		return

	if not TargetManager.assign_target(new_target, self):
		return

	current_target = new_target
	if target_search_timer.is_stopped():
		target_search_timer.start(target_search_cooldown)

func _on_target_removed(target: Node) -> void:
	if current_target == target:
		current_target = null

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
