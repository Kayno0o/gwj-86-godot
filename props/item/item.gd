class_name Item extends Node2D

func _ready() -> void:
	TargetManager.register_target(self, ["item"])
