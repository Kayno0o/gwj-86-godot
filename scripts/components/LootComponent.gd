class_name LootComponent extends Component

var loot_scene: PackedScene
var loot_amount: int
var spawn_spread: float

func _init(
	p_loot_scene: PackedScene,
	p_loot_amount: int,
	p_spawn_spread: float = 16.0,
) -> void:
	type = Component.Type.Loot
	loot_scene = p_loot_scene
	loot_amount = p_loot_amount
	spawn_spread = p_spawn_spread

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
