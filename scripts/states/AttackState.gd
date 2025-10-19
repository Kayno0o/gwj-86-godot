class_name AttackState extends State

var attack_timer: Timer

func init(p_parent: Entity) -> void:
	type = State.Type.Attack

	super.init(p_parent)

	attack_timer = Timer.new()
	attack_timer.one_shot = true
	attack_timer.timeout.connect(_on_attack_timeout)
	add_child(attack_timer)

func enter() -> void:
	parent.velocity = Vector2.ZERO

	attack_timer.start(parent.get_attack_speed())

func exit() -> void:
	attack_timer.stop()

func process(_delta: float):
	if not parent.current_target or not is_instance_valid(parent.current_target):
		parent.current_target = null
		return State.Type.Idle

	var distance = parent.global_position.distance_to(parent.current_target.global_position)
	if distance > parent.get_attack_range():
		return State.Type.MoveToTarget

	return null

func _on_attack_timeout():
	var target = parent.current_target
	if not target or not is_instance_valid(target):
		parent.current_target = null
		return

	var pixels = parent.get_attack_range() / 4
	var orientation = (target.global_position - parent.global_position).normalized() * pixels

	var tween: Tween = get_tree().create_tween()
	tween.tween_property(parent, "global_position", parent.global_position + orientation, 0.1) \
		.set_trans(Tween.TRANS_SINE) \
		.set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(parent, "global_position", parent.global_position - orientation, 0.1) \
		.set_trans(Tween.TRANS_SINE) \
		.set_ease(Tween.EASE_IN_OUT)

	var health_comp: HealthComponent = Utils.get_component(target, Component.Type.Health)
	if health_comp.hit(parent.get_attack()):
		TargetManager.stop_targeting(parent.current_target, parent)
		parent.current_target = null
		return

	attack_timer.start(parent.get_attack_speed())
