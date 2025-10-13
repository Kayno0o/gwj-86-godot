class_name ResourceProps extends StaticBody2D

@export var target_types: Array[Enum.TargetType]
@export var health: float

@export_category("Loot")
@export var loot_scene: PackedScene
@export var loot_amount: int
@export var spawn_spread: float = 16.0

@onready var health_component: HealthComponent = HealthComponent.new(health)
@onready var loot_component: LootComponent = LootComponent.new(loot_scene, loot_amount, spawn_spread)

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

	print(global_position, get_parent())
	if loot_component.spawn_loot(global_position, get_parent()):
		queue_free()
