class_name Item extends Node2D

@export var item_type: Enum.ItemType

var target_type: Enum.TargetType = Enum.TargetType.Item

func _ready() -> void:
	TargetManager.register_target(self, [target_type])
