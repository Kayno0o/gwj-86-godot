class_name Item extends Node2D

@export var item_type: Enum.ItemType

var target_type: Enum.TargetType = Enum.TargetType.Item

func _ready() -> void:
	TargetManager.register_target(self, [target_type])

func fly_to(target_pos: Vector2):
	var tween = get_tree().create_tween()
	tween.tween_property(self, "global_position", target_pos, 0.5) \
		.set_trans(Tween.TRANS_SINE) \
		.set_ease(Tween.EASE_IN_OUT)
	tween.tween_callback(queue_free.bind())
