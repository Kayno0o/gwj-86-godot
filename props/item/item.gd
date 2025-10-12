class_name Item extends Node2D

var target_type: TargetManager.Type = TargetManager.Type.Item

func _ready() -> void:
	TargetManager.register_target(self, [target_type])
