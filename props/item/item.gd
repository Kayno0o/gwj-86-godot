class_name Item extends Node2D

enum ItemType {
	Wood = 0,
	Stone = 1,
}

@export var item_type: ItemType

var target_type: Enum.TargetType = Enum.TargetType.Item

func _ready() -> void:
	TargetManager.register_target(self, [target_type])
