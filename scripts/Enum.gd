extends Node

enum EntityType {
	MaskLumberjack = 0,
	MaskMiner = 1,
	MaskAttacker = 2,
	MaskTank = 3,

	Enemy = 10,
}

## Behavior profiles define target priorities for each entity type
## Each entry maps to an array of target type arrays, ordered by priority (highest first)
const BEHAVIOR_PROFILES: Dictionary[EntityType, Array] = {
	EntityType.MaskLumberjack: [
		[TargetManager.Type.Enemy],
		[TargetManager.Type.Tree, TargetManager.Type.Item],
	],
	EntityType.MaskMiner: [
		[TargetManager.Type.Enemy],
		[TargetManager.Type.Rock, TargetManager.Type.Item],
	],
	EntityType.MaskAttacker: [
		[TargetManager.Type.Enemy],
		[TargetManager.Type.Item],
	],
	EntityType.MaskTank: [
		[TargetManager.Type.Enemy],
	],
	EntityType.Enemy: [
		[TargetManager.Type.Mask],
	],
}

## Get the target priorities for a given entity type
func get_target_priorities(entity_type: EntityType) -> Array[Array]:
	if BEHAVIOR_PROFILES.has(entity_type):
		var result: Array[Array] = []
		result.assign(BEHAVIOR_PROFILES[entity_type])
		return result
	return []
