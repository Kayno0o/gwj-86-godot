class_name Hero extends Mask

@export var sprites: Dictionary[Enum.EntityType, SpriteFrames] = {
	Enum.EntityType.MaskLumberjack: null,
	Enum.EntityType.MaskMiner: null,
	Enum.EntityType.MaskAttacker: null,
	Enum.EntityType.MaskTank: null,
	Enum.EntityType.MaskFarmer: null,
	Enum.EntityType.MaskTransporter: null,
}
@export var respawn_cooldown: float = 20.0

func _ready():
	super._ready()
	_on_mask_change(type)

func get_health() -> float:
	return stats[Enum.Stat.Health] + (StatsManager.sum_bonuses(Enum.Stat.Health) / 2)

func get_inventory_size() -> float:
	return stats[Enum.Stat.InventorySize] + StatsManager.sum_bonuses(Enum.Stat.InventorySize)
func get_pickup_range() -> float:
	return stats[Enum.Stat.PickupRange] + get_bonus(Enum.Stat.PickupRange) * 2.0
func get_target_search_cooldown() -> float:
	return stats[Enum.Stat.TargetSearchCooldown] + get_bonus(Enum.Stat.TargetSearchCooldown) * 2.0

func get_attack() -> float:
	return stats[Enum.Stat.Attack] + get_bonus(Enum.Stat.Attack) * 2.0
func get_attack_speed() -> float:
	return stats[Enum.Stat.AttackSpeed] + get_bonus(Enum.Stat.AttackSpeed) * 2.0
func get_attack_range() -> float:
	return stats[Enum.Stat.AttackRange] + get_bonus(Enum.Stat.AttackRange) * 2.0
func get_attack_view_distance() -> float:
	return stats[Enum.Stat.AttackViewDistance] + get_bonus(Enum.Stat.AttackViewDistance)

func get_movement_speed() -> float:
	return stats[Enum.Stat.MovementSpeed] + get_bonus(Enum.Stat.MovementSpeed) * 2.0

func _on_mask_change(new_type: Enum.EntityType) -> void:
	type = new_type
	
	var animated_sprite: AnimatedSprite2D = sprite
	animated_sprite.sprite_frames = sprites[new_type]

	state_machine.change_state_type(State.Type.Idle)
