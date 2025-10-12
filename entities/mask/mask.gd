extends CharacterBody2D
class_name Mask

@export_category("Base")
@export var mask_name: String = "Mask"
@export var type: Enum.EntityType

@export var _movement_speed: float = 50.0

@export_category("Attack")
@export var _attack: float = 5
@export var _attack_speed: float = 1.0
@export var _attack_range: float = 30.0
@export var _attack_view_distance: float = 15.0

@export_category("Pickup")
@export var _inventory_size: int = 1
@export var _pickup_range: float = 30.0
@export var _target_search_cooldown: float = 2.0

@export var interested_target_types: Array[String] = ["tree", "item"]

var current_target: Node = null

var damage_timer: Timer

func _ready():
	apply_mask_properties()

	damage_timer = Timer.new()
	damage_timer.one_shot = false
	add_child(damage_timer)

func _physics_process(delta):
	on_physics_process(delta)

func on_physics_process(_delta) -> void:
	return

func apply_mask_properties():
	if not is_node_ready():
		return

func get_entity_type() -> Enum.EntityType:
	return type

func get_mask_name() -> String:
	return mask_name

func on_check_distance(_distance: float) -> bool:
	return false

func move_to_target():
	if not current_target or not is_instance_valid(current_target):
		current_target = null
		return

	var direction = (current_target.global_position - global_position).normalized()
	var distance: float = global_position.distance_to(current_target.global_position)

	if on_check_distance(distance):
		return

	velocity = direction * get_movement_speed()
	move_and_slide()


func get_movement_speed() -> float:
	return SkillTreeManager.get_fstat(type, SkillTreeManager.StatType.MovementSpeed, _movement_speed)
func get_attack() -> float:
	return SkillTreeManager.get_fstat(type, SkillTreeManager.StatType.Attack, _attack)
func get_attack_speed() -> float:
	return SkillTreeManager.get_fstat(type, SkillTreeManager.StatType.AttackSpeed, _attack_speed)
func get_attack_range() -> float:
	return SkillTreeManager.get_fstat(type, SkillTreeManager.StatType.AttackRange, _attack_range)
func get_attack_view_distance() -> float:
	return SkillTreeManager.get_fstat(type, SkillTreeManager.StatType.AttackViewDistance, _attack_view_distance)
func get_inventory_size() -> int:
	return SkillTreeManager.get_istat(type, SkillTreeManager.StatType.InventorySize, _inventory_size)
func get_pickup_range() -> float:
	return SkillTreeManager.get_fstat(type, SkillTreeManager.StatType.PickupRange, _pickup_range)
func get_target_search_cooldown() -> float:
	return SkillTreeManager.get_fstat(type, SkillTreeManager.StatType.TargetSearchCooldown, _target_search_cooldown)
