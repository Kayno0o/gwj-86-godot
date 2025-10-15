extends Node

enum StatType {
	MovementSpeed = 0,
	Health = 1,

	Attack = 10,
	AttackSpeed = 11,
	AttackRange = 12,
	AttackViewDistance = 13,

	InventorySize = 20,
	PickupRange = 21,
	TargetSearchCooldown = 22,
}

var _bonuses: Dictionary = {
	StatType.MovementSpeed: 0.0,
	StatType.Health: 0.0,

	StatType.Attack: 0.0,
	StatType.AttackSpeed: 0.0,
	StatType.AttackRange: 0.0,
	StatType.AttackViewDistance: 0.0,

	StatType.InventorySize: 0,
	StatType.PickupRange: 0.0,
	StatType.TargetSearchCooldown: 0.0,
}

var stat_bonuses: Dictionary = {}

func _init() -> void:
	for entity_type in Enum.EntityType.values():
		stat_bonuses[entity_type] = _bonuses.duplicate()

func get_fstat(entity_type: Enum.EntityType, stat_type: StatType, value: float) -> float:
	return stat_bonuses[entity_type][stat_type] + value

func get_istat(entity_type: Enum.EntityType, stat_type: StatType, value: int) -> int:
	return stat_bonuses[entity_type][stat_type] + value
