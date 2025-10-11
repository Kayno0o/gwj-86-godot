class_name LootComponent extends Node

@export_category("Loot")
@export var loot_scene: PackedScene
@export var loot_amount: int
@export var spawn_spread: float = 16.0

func spawn_loot(at_position: Vector2, parent: Node) -> bool:
	if not loot_scene:
		return false

	for i in range(loot_amount):
		var loot_instance = loot_scene.instantiate()
		loot_instance.global_position = at_position

		var offset = Vector2(
			randf_range(-spawn_spread, spawn_spread),
			randf_range(-spawn_spread, spawn_spread),
		)
		loot_instance.global_position += offset

		parent.add_child(loot_instance)

	return true
