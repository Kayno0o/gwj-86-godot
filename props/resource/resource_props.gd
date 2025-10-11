class_name ResourceProps extends StaticBody2D

@onready var health_component: HealthComponent = $Components/HealthComponent
@onready var loot_component: LootComponent = $Components/LootComponent
@onready var interactable_component: TargetComponent = $Components/TargetComponent

func _ready() -> void:
	health_component.death.connect(on_death)

func on_damage(damage: float):
	health_component.on_damage(damage)

func on_death():
	if loot_component:
		if loot_component.spawn_loot(global_position, get_parent()):
			queue_free()
