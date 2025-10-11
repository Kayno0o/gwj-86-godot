extends StaticBody2D
class_name ResourceProps

@export var health: float
@export var loot_scene: PackedScene
@export var loot_count: int = 1

var is_targeted: bool = false

func on_damage(damage: float):
	health -= damage

	if health < 0:
		on_break()

func on_break():
	if loot_scene:
		for i in range(loot_count):
			var loot_instance = loot_scene.instantiate()
			loot_instance.global_position = global_position

			var offset = Vector2(randf_range(-16, 16), randf_range(-16, 16))
			loot_instance.global_position += offset

			get_parent().add_child(loot_instance)

	queue_free()
	return
