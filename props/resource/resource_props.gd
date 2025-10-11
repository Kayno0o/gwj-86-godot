class_name ResourceProps extends StaticBody2D

@export var target_types: Array[String] = []

@onready var health_component: HealthComponent = $Components/HealthComponent
@onready var loot_component: LootComponent = $Components/LootComponent

func _ready() -> void:
	health_component.death.connect(on_death)

	TargetManager.register_target(self, target_types)

func on_damage(damage: float):
	health_component.on_damage(damage)

func on_death():
	if loot_component:
		if loot_component.spawn_loot(global_position, get_parent()):
			queue_free()
