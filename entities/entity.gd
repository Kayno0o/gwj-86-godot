class_name Entity extends CharacterBody2D

var current_target: Node2D = null

@export_category("Base")
@export var type: Enum.EntityType
@export var target_type: Enum.TargetType
@export var entity_name: String = "Entity"
@export var health: float = 5.0

@export_category("Pickup")
@export var inventory_size: int = 1
@export var pickup_range: float = 42.0
@export var target_search_cooldown: float = 2.0
@export var deposit_speed: float = 0.2

@export_category("Attack")
@export var attack: float = 5
@export var attack_speed: float = 1.0
@export var attack_range: float = 42.0
@export var attack_view_distance: float = 300.0

@export_category("Movement")
@export var movement_speed: float = 50.0
@export var totem_approach_distance: float = 100.0
@export var wandering_distance: float = 48.0
@export var wandering_cooldown: float = 4.0

@onready var sprite: Node2D = $Sprite

@onready var health_component: HealthComponent = HealthComponent.new(SkillTreeManager.get_fstat(type, SkillTreeManager.StatType.Health, health))
@onready var inventory_component: InventoryComponent = InventoryComponent.new(self, SkillTreeManager.get_istat(type, SkillTreeManager.StatType.InventorySize, inventory_size))

@onready var components: Dictionary[Component.Type, Component] = {
	Component.Type.Health: health_component,
	Component.Type.Inventory: inventory_component,
}

func _ready() -> void:
	print(sprite)
	TargetManager.register_target(self, [target_type])
	TargetManager.target_removed.connect(_on_target_removed)
	health_component.death.connect(on_death)
	inventory_component._ready()

func on_death():
	TargetManager.unregister_target(self, [target_type])
	queue_free()

func _on_target_removed(target: Node) -> void:
	if current_target == target:
		current_target = null

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
