extends Node

enum EntityType {
	MaskLumberjack,
	MaskMiner,
	MaskAttacker,
	MaskTank,
	Enemy,
}

## Behavior profiles define target priorities for each entity type
## Each entry maps to an array of target type arrays, ordered by priority (highest first)
const BEHAVIOR_PROFILES = {
	EntityType.MaskLumberjack: {
		"primary_targets": ["enemy"],
		"secondary_targets": ["tree", "item"],
		"tertiary_targets": [],
	},
	EntityType.MaskMiner: {
		"primary_targets": ["enemy"],
		"secondary_targets": ["stone", "item"],
		"tertiary_targets": [],
	},
	EntityType.MaskAttacker: {
		"primary_targets": ["enemy"],
		"secondary_targets": ["item"],
		"tertiary_targets": [],
	},
	EntityType.MaskTank: {
		"primary_targets": ["enemy"],
		"secondary_targets": [],
		"tertiary_targets": [],
	},
	EntityType.Enemy: {
		"primary_targets": ["mask"],
		"secondary_targets": [],
		"tertiary_targets": [],
	},
}

## Get the target priorities for a given entity type
func get_target_priorities(entity_type: EntityType) -> Dictionary:
	if BEHAVIOR_PROFILES.has(entity_type):
		return BEHAVIOR_PROFILES[entity_type]
	return {
		"primary_targets": [],
		"secondary_targets": [],
		"tertiary_targets": [],
	}
