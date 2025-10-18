extends Node

var _bonuses: Dictionary = {
	Enum.StatType.MovementSpeed: 0.0,
	Enum.StatType.Health: 0.0,

	Enum.StatType.Attack: 0.0,
	Enum.StatType.AttackSpeed: 0.0,
	Enum.StatType.AttackRange: 0.0,
	Enum.StatType.AttackViewDistance: 0.0,

	Enum.StatType.InventorySize: 0,
	Enum.StatType.PickupRange: 0.0,
	Enum.StatType.TargetSearchCooldown: 0.0,
}

var stat_bonuses: Dictionary[Enum.EntityType, Dictionary] = {}

func init() -> void:
	for entity_type in Enum.EntityType.values():
		stat_bonuses[entity_type] = _bonuses.duplicate()

func get_fstat(entity_type: Enum.EntityType, stat_type: Enum.StatType, value: float) -> float:
	return stat_bonuses[entity_type][stat_type] + value

func get_istat(entity_type: Enum.EntityType, stat_type: Enum.StatType, value: int) -> int:
	return stat_bonuses[entity_type][stat_type] + value

func add_bonuses(entity_type: Enum.EntityType, bonuses: Dictionary[Enum.StatType, float]) -> void:
	for stat_type in bonuses:
		stat_bonuses[entity_type][stat_type] += bonuses[stat_type]
