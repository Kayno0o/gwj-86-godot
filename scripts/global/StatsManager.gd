extends Node

var _bonuses: Dictionary = {
	Enum.Stat.MovementSpeed: 0.0,
	Enum.Stat.Health: 0.0,

	Enum.Stat.Attack: 0.0,
	Enum.Stat.AttackSpeed: 0.0,
	Enum.Stat.AttackRange: 0.0,
	Enum.Stat.AttackViewDistance: 0.0,

	Enum.Stat.InventorySize: 0,
	Enum.Stat.PickupRange: 0.0,
	Enum.Stat.TargetSearchCooldown: 0.0,
}

var stat_bonuses: Dictionary[Enum.EntityType, Dictionary] = {}

func init() -> void:
	for entity_type in Enum.EntityType.values():
		stat_bonuses[entity_type] = _bonuses.duplicate()

func get_bonus(entity_type: Enum.EntityType, stat_type: Enum.Stat) -> float:
	return stat_bonuses[entity_type][stat_type]

func get_stat(entity_type: Enum.EntityType, stat_type: Enum.Stat, value: float) -> float:
	return get_bonus(entity_type, stat_type) + value

func sum_bonuses(stat_type: Enum.Stat) -> float:
	var total = 0.0

	for value in stat_bonuses.values():
		total += value[stat_type]

	return total

func add_bonuses(entity_type: Enum.EntityType, bonuses: Dictionary[Enum.Stat, float]) -> void:
	for stat_type in bonuses:
		stat_bonuses[entity_type][stat_type] += bonuses[stat_type]
