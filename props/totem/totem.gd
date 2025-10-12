extends Node2D

var target_type: Enum.TargetType = Enum.TargetType.Totem;

func _ready() -> void:
	TargetManager.register_target(self, [target_type])
