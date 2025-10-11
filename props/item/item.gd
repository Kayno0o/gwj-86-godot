class_name Item extends Node2D

@export var type: ItemType.Type

func _ready() -> void:
	TargetManager.register_target(self, ["item"])
