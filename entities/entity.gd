class_name Entity extends CharacterBody2D

@export_category("Base")
@export var type: Enum.EntityType
@export var target_type: TargetManager.Type
@export var entity_name: String = "Entity"
@export var movement_speed: float = 50.0

@export_category("Pickup")
@export var inventory_size: int = 1
@export var pickup_range: float = 30.0
@export var target_search_cooldown: float = 2.0

@export_category("Attack")
@export var attack: float = 5
@export var attack_speed: float = 1.0
@export var attack_range: float = 30.0
@export var attack_view_distance: float = 15.0

@export var health_component: Component

@onready var components: Dictionary[Component.Type, Component] = {
	Component.Type.Health: health_component
}

var current_target: Node = null

func _ready() -> void:
	TargetManager.target_removed.connect(_on_target_removed)
	health_component.death.connect(on_death)

func on_death():
	TargetManager.unregister_target(self, [target_type])
	queue_free()

func _on_target_removed(target: Node) -> void:
	if current_target == target:
		current_target = null

func find_target() -> Node:
	var priorities_group = Enum.get_target_priorities(type)
	if priorities_group.is_empty():
		return null

	for priorities in priorities_group:
		if priorities.is_empty():
			continue

		var typed_priorities: Array[TargetManager.Type] = []
		typed_priorities.assign(priorities)

		var target = TargetManager.get_nearest_available_target(
			global_position,
			typed_priorities,
			self,
		)

		if target:
			return target

	return null

func get_movement_speed() -> float:
	return SkillTreeManager.get_fstat(type, SkillTreeManager.StatType.MovementSpeed, movement_speed)

func get_inventory_size() -> int:
	return SkillTreeManager.get_istat(type, SkillTreeManager.StatType.InventorySize, inventory_size)
func get_pickup_range() -> float:
	return SkillTreeManager.get_fstat(type, SkillTreeManager.StatType.PickupRange, pickup_range)
func get_target_search_cooldown() -> float:
	return SkillTreeManager.get_fstat(type, SkillTreeManager.StatType.TargetSearchCooldown, target_search_cooldown)

func get_attack() -> float:
	return SkillTreeManager.get_fstat(type, SkillTreeManager.StatType.Attack, attack)
func get_attack_speed() -> float:
	return SkillTreeManager.get_fstat(type, SkillTreeManager.StatType.AttackSpeed, attack_speed)
func get_attack_range() -> float:
	return SkillTreeManager.get_fstat(type, SkillTreeManager.StatType.AttackRange, attack_range)
func get_attack_view_distance() -> float:
	return SkillTreeManager.get_fstat(type, SkillTreeManager.StatType.AttackViewDistance, attack_view_distance)
