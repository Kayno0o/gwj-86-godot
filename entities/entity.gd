class_name Entity extends CharacterBody2D

var current_target: Node2D = null

@export_category("Base")
@export var type: Enum.EntityType
@export var target_type: Enum.TargetType
@export var entity_name: String = "Entity"

@export var stats: Dictionary[Enum.Stat, float] = {
	Enum.Stat.Health: 5.0,
	Enum.Stat.InventorySize: 1.0,
	Enum.Stat.PickupRange: 42.0,
	Enum.Stat.TargetSearchCooldown: 2.0,
	Enum.Stat.Attack: 5,
	Enum.Stat.AttackSpeed: 1.0,
	Enum.Stat.AttackRange: 42.0,
	Enum.Stat.AttackViewDistance: 300.0,
	Enum.Stat.MovementSpeed: 50.0,
}

@export_category("Pickup")
@export var deposit_speed: float = 0.2

@export_category("Movement")
@export var totem_approach_distance: float = 100.0
@export var wandering_distance: float = 48.0
@export var wandering_cooldown: float = 4.0

@onready var sprite: Node2D = $Sprite

var inventory_component: InventoryComponent = null

@onready var health_component: HealthComponent = HealthComponent.new(get_health)

@onready var components: Dictionary[Component.Type, Component] = {
	Component.Type.Health: health_component,
}

func _ready() -> void:
	TargetManager.register_target(self, [target_type])
	TargetManager.target_removed.connect(_on_target_removed)
	health_component.death.connect(_on_death)

func find_closer_target() -> Node:
	var priorities_group = Enum.get_target_priorities(type)
	if priorities_group.is_empty():
		return null

	# check target by priorities, from first to last
	for priorities in priorities_group:
		if priorities.is_empty():
			continue

		# enforce type
		var typed_priorities: Array[Enum.TargetType] = []
		typed_priorities.assign(priorities)

		var target = TargetManager.get_nearest_available_target(
			global_position,
			typed_priorities,
			self,
		)

		if not target:
			continue

		var distance = global_position.distance_to(target.global_position)

		# check if should fight mask/villain
		var is_mask = target_type == Enum.TargetType.Mask
		var is_villain = target_type == Enum.TargetType.Villain

		if is_mask and TargetManager.target_has_type(target, Enum.TargetType.Villain) \
		or is_villain and TargetManager.target_has_type(target, Enum.TargetType.Mask):
			if distance > get_attack_view_distance():
				continue

		return target

	return null

func get_bonus(stat: Enum.Stat) -> float:
	return StatsManager.get_bonus(type, stat)

func get_stat(stat: Enum.Stat) -> float:
	return StatsManager.get_stat(type, stat, stats[stat])


func get_health() -> float:
	return get_stat(Enum.Stat.Health)

func get_inventory_size() -> float:
	return get_stat(Enum.Stat.InventorySize)
func get_pickup_range() -> float:
	return get_stat(Enum.Stat.PickupRange)
func get_target_search_cooldown() -> float:
	return get_stat(Enum.Stat.TargetSearchCooldown)

func get_attack() -> float:
	return get_stat(Enum.Stat.Attack)
func get_attack_speed() -> float:
	return get_stat(Enum.Stat.AttackSpeed)
func get_attack_range() -> float:
	return get_stat(Enum.Stat.AttackRange)
func get_attack_view_distance() -> float:
	return get_stat(Enum.Stat.AttackViewDistance)

func get_movement_speed() -> float:
	return get_stat(Enum.Stat.MovementSpeed)

func _on_death():
	TargetManager.unregister_target(self, [target_type])
	if inventory_component:
		inventory_component.drop_inventory()
	queue_free()

func _on_target_removed(target: Node) -> void:
	if current_target == target:
		current_target = null
