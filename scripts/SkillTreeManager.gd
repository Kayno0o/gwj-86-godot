class_name SkillTreeManager extends Node

enum StatType {
	InventorySize,
	
	CheckCooldown,
	PickupDistance,
	MovementSpeed,

	Attack,
	AttackSpeed,
	AttackRange,
	AttackDistance,
}

var stat_bonuses: Dictionary = {
	StatType.InventorySize: 0,
	StatType.CheckCooldown: 0.0,
	StatType.PickupDistance: 0.0,
	StatType.MovementSpeed: 0.0,
	StatType.Attack: 0.0,
	StatType.AttackSpeed: 0.0,
	StatType.AttackRange: 0.0,
	StatType.AttackDistance: 0.0,
}

func get_fstat(stat_type: StatType, value: float) -> float:
	return stat_bonuses[stat_type] + value

func get_istat(stat_type: StatType, value: int) -> int:
	return stat_bonuses[stat_type] + value
