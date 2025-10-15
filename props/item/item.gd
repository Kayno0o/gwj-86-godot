class_name Item extends Node2D

@export var item_type: Enum.ItemType

var target_type: Enum.TargetType = Enum.TargetType.Item
var current_tween: Tween

func _ready() -> void:
	TargetManager.register_target(self, [target_type])

func _on_current_tween_finished() -> void:
	current_tween = null

func tween_to(target_pos: Vector2, duration: float = 0.5, property: String = "global_position") -> Tween:
	if current_tween:
		current_tween.stop()
		current_tween = null

	var tween = get_tree().create_tween()
	tween.tween_property(self, property, target_pos, duration) \
		.set_trans(Tween.TRANS_SINE) \
		.set_ease(Tween.EASE_IN_OUT)

	current_tween = tween
	current_tween.finished.connect(_on_current_tween_finished)

	return tween

func fly_to(target_pos: Vector2, duration: float = 0.5, property: String = "global_position") -> Tween:
	var tween: Tween = tween_to(target_pos, duration, property)
	tween.tween_callback(queue_free.bind())

	return tween
