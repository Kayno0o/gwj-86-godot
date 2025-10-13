extends Node

enum ItemType {
	Wood = 0,
	Stone = 1,
}

enum EntityType {
	MaskLumberjack = 0,
	MaskMiner = 1,
	MaskAttacker = 2,
	MaskTank = 3,

	Enemy = 10,
}

enum TargetType {
	Resource = 0,
	Tree = 1,
	Rock = 2,

	Enemy = 10,
	Mask = 11,

	Item = 20,

	Totem = 30,
}

## highest to lowest priority
const BEHAVIOR_PROFILES: Dictionary[EntityType, Array] = {
	EntityType.MaskLumberjack: [
		[Enum.TargetType.Enemy],
		[Enum.TargetType.Tree, Enum.TargetType.Item],
	],
	EntityType.MaskMiner: [
		[Enum.TargetType.Enemy],
		[Enum.TargetType.Rock, Enum.TargetType.Item],
	],
	EntityType.MaskAttacker: [
		[Enum.TargetType.Enemy],
		[Enum.TargetType.Item],
	],
	EntityType.MaskTank: [
		[Enum.TargetType.Enemy],
		[Enum.TargetType.Totem],
	],
	EntityType.Enemy: [
		[Enum.TargetType.Mask],
		[Enum.TargetType.Totem],
	],
}

func get_target_priorities(entity_type: EntityType) -> Array[Array]:
	if BEHAVIOR_PROFILES.has(entity_type):
		var result: Array[Array] = []
		result.assign(BEHAVIOR_PROFILES[entity_type])
		return result
	return []
