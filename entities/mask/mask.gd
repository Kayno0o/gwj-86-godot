extends CharacterBody2D
class_name Mask

@export_category("Base")
@export var mask_name: String = "Mask"
@export var type: Enum.EntityType

@export var movement_speed: float = 50.0

@export_category("Attack")
@export var attack: float = 5
@export var attack_speed: float = 1.0
@export var attack_range: float = 30.0
@export var attack_view_distance: float = 15.0

@export_category("Pickup")
@export var inventory_size: int = 1
@export var pickup_range: float = 30.0
@export var target_search_cooldown: float = 2.0

@onready var state_machine: StateMachine = $StateMachine

var current_target: Node = null
var damage_timer: Timer

func _ready():
	apply_mask_properties()

	damage_timer = Timer.new()
	damage_timer.one_shot = false
	add_child(damage_timer)

	# Subscribe to target removed events
	TargetManager.target_removed.connect(_on_target_removed)

func _physics_process(delta):
	# Update state machine if it exists
	if state_machine:
		state_machine.update(delta)
	else:
		# Fallback to old behavior for backward compatibility
		on_physics_process(delta)

func on_physics_process(_delta) -> void:
	return

func apply_mask_properties():
	if not is_node_ready():
		return

func _on_target_removed(target: Node) -> void:
	if current_target == target:
		current_target = null

func get_entity_type() -> Enum.EntityType:
	return type

func get_mask_name() -> String:
	return mask_name

func get_movement_speed() -> float:
	return SkillTreeManager.get_fstat(type, SkillTreeManager.StatType.MovementSpeed, movement_speed)
func get_attack() -> float:
	return SkillTreeManager.get_fstat(type, SkillTreeManager.StatType.Attack, attack)
func get_attack_speed() -> float:
	return SkillTreeManager.get_fstat(type, SkillTreeManager.StatType.AttackSpeed, attack_speed)
func get_attack_range() -> float:
	return SkillTreeManager.get_fstat(type, SkillTreeManager.StatType.AttackRange, attack_range)
func get_attack_view_distance() -> float:
	return SkillTreeManager.get_fstat(type, SkillTreeManager.StatType.AttackViewDistance, attack_view_distance)
func get_inventory_size() -> int:
	return SkillTreeManager.get_istat(type, SkillTreeManager.StatType.InventorySize, inventory_size)
func get_pickup_range() -> float:
	return SkillTreeManager.get_fstat(type, SkillTreeManager.StatType.PickupRange, pickup_range)
func get_target_search_cooldown() -> float:
	return SkillTreeManager.get_fstat(type, SkillTreeManager.StatType.TargetSearchCooldown, target_search_cooldown)
