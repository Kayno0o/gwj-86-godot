class_name IdleState extends State

var search_timer: Timer

func init(p_parent: Entity) -> void:
	type = State.Type.Idle

	super.init(p_parent)

	search_timer = Timer.new()
	search_timer.one_shot = true
	search_timer.timeout.connect(_on_search_timeout)
	add_child(search_timer)

func enter() -> void:
	parent.velocity = Vector2.ZERO
	search_timer.start(parent.get_target_search_cooldown())

func exit() -> void:
	search_timer.stop()

func process(_delta):
	if parent.current_target and is_instance_valid(parent.current_target):
		return State.Type.MoveToTarget

func _on_search_timeout() -> void:
	search_target()
	search_timer.start(parent.get_target_search_cooldown())

func search_target() -> void:
	var new_target = parent.find_target()

	if new_target:
		if parent.current_target:
			TargetManager.release_target(parent.current_target, parent)

		if not TargetManager.assign_target(new_target, parent):
			return

		parent.current_target = new_target
