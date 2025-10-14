class_name IdleState extends State

var search_timer: Timer
var should_deposit: bool = false

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
	should_deposit = false

func exit() -> void:
	search_timer.stop()

func process(_delta):
	if parent.current_target and is_instance_valid(parent.current_target):
		return State.Type.MoveToTarget
	
	if should_deposit:
		return State.Type.DepositItem

func _on_search_timeout() -> void:
	search_target()
	search_timer.start(parent.get_target_search_cooldown())

func search_target() -> void:
	var new_target = parent.find_closer_target()

	if new_target:
		if parent.current_target:
			TargetManager.stop_targeting(parent.current_target, parent)

		if not TargetManager.start_targeting(new_target, parent):
			return

		parent.current_target = new_target

		return

	if not parent.current_target and not parent.inventory_component.is_empty():
		should_deposit = true
