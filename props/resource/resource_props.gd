class_name ResourceProps extends StaticBody2D

@export var target_types: Array[Enum.TargetType]

@export var health_component: HealthComponent
@export var loot_component: LootComponent

@onready var components = {
	Component.Type.Health: health_component,
	Component.Type.Loot: loot_component,
}

func _ready() -> void:
	health_component.death.connect(on_death)

	TargetManager.register_target(self, target_types)

func on_damage(damage: float):
	return health_component.on_damage(damage)

func on_death():
	TargetManager.unregister_target(self, target_types)

	if loot_component:
		if loot_component.spawn_loot(global_position, get_parent()):
			queue_free()
