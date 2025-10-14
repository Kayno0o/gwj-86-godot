extends Node

enum EntityType {
	MaskLumberjack = 0,
	MaskMiner = 1,
	MaskAttacker = 2,
	MaskTank = 3,
	MaskFarmer = 4,

	Villain = 10,
}

enum ItemType {
	Wood = 0,
	Stone = 1,
	Wheat = 2,
	Soul = 3,
}

enum TargetType {
	Resource = 0,
	Tree = 1,
	Rock = 2,
	Wheat = 3,

	Villain = 10,
	Mask = 11,

	Item = 20,

	Totem = 30,
}

var ongoing_shopping_list : Array[Dictionary] # Array of Dictionnary full of Enums, it counts
var current_shopping_list : Dictionary

## highest to lowest priority
const BEHAVIOR_PROFILES: Dictionary[EntityType, Array] = {
	EntityType.MaskLumberjack: [
		[Enum.TargetType.Villain],
		[Enum.TargetType.Tree, Enum.TargetType.Item],
	],
	EntityType.MaskMiner: [
		[Enum.TargetType.Villain],
		[Enum.TargetType.Rock, Enum.TargetType.Item],
	],
		EntityType.MaskFarmer: [
		[Enum.TargetType.Villain],
		[Enum.TargetType.Wheat, Enum.TargetType.Item],
	],
	EntityType.MaskAttacker: [
		[Enum.TargetType.Villain],
		[Enum.TargetType.Item],
	],
	EntityType.MaskTank: [
		[Enum.TargetType.Villain],
		[Enum.TargetType.Totem],
	],
	EntityType.Villain: [
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
