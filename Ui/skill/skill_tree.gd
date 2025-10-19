class_name SkillTree extends Control

@export var default_entity_type: Enum.EntityType
@export var circle_radius: float = 600.0
@export var animation_duration: float = 0.5
@export var animation_delay_between_skills: float = 0.05

var is_expanded: bool = false

func _ready() -> void:
	# direct children are the root upgrades
	for child in get_children():
		child.visible = false

		# their child are non-available upgrades
		for sub_child in child.get_children():
			if sub_child is SkillNode:
				sub_child.set_process(false)
				sub_child.visible = false

	_collapse_skills()

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			_toggle_skills()

func _toggle_skills() -> void:
	if is_expanded:
		_collapse_skills()
	else:
		_expand_skills()
	is_expanded = !is_expanded

func _collapse_skills() -> void:
	var children = get_children()
	var center = size / 2
	
	for i in range(children.size()):
		var child = children[i]
		
		# disable mouse interaction during animation
		child.mouse_filter = MOUSE_FILTER_IGNORE
		
		var tween = create_tween()
		tween.tween_property(child, "position", center - child.size / 2, animation_duration).set_delay(i * animation_delay_between_skills) \
			.set_trans(Tween.TRANS_BACK) \
			.set_ease(Tween.EASE_IN)
		
		tween.tween_callback(func(): child.visible = false)

func _on_bought_skill():
	_expand_skills()

func _expand_skills() -> void:
	var children = get_children()
	var num_children = children.size()

	if num_children == 0:
		return

	var center = size / 2
	var angle_step = TAU / num_children

	for i in range(num_children):
		var child = children[i]

		# disable mouse interaction during animation
		child.mouse_filter = MOUSE_FILTER_IGNORE

		child.position = center - child.size / 2
		child.visible = true

		var angle = i * angle_step - PI / 2
		var target_pos = Vector2(
			center.x + circle_radius * cos(angle),
			center.y + circle_radius * sin(angle)
		) - child.size / 2

		var tween = create_tween()
		tween.tween_property(child, "position", target_pos, animation_duration).set_delay(i * animation_delay_between_skills) \
			.set_trans(Tween.TRANS_BACK) \
			.set_ease(Tween.EASE_OUT)

		# Re-enable mouse interaction after animation completes
		tween.tween_callback(func(): child.mouse_filter = MOUSE_FILTER_STOP)
