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

var spawn_position: Vector2
var respawn_timer: Timer

var available_masks: Array[Enum.EntityType] = [
	Enum.EntityType.MaskLumberjack,
	Enum.EntityType.MaskMiner,
	Enum.EntityType.MaskAttacker,
	Enum.EntityType.MaskTank,
	Enum.EntityType.MaskFarmer,
	Enum.EntityType.MaskTransporter,
]

func _ready():
	super._ready()

	spawn_position = global_position

	respawn_timer = Timer.new()
	respawn_timer.one_shot = true
	respawn_timer.wait_time = respawn_cooldown
	respawn_timer.process_mode = Node.PROCESS_MODE_ALWAYS
	add_child(respawn_timer)
	respawn_timer.timeout.connect(_on_respawn)

	InventoryManager.totem.hero_switch.connect(_on_switch_mask)

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

func _on_switch_mask(index: int):
	type = available_masks.get(index)
	
	$Sprite.frame = index

	state_machine.change_state_type(State.Type.Idle)

func update_sprite_direction() :
	return

func _on_death(_die = false):
	var tween = super._on_death(false)
	
	tween.finished.connect(func():
		visible = false
		process_mode = Node.PROCESS_MODE_DISABLED
		respawn_timer.start()
	)

func _on_respawn():
	global_position = spawn_position
	rotation_degrees = 0
	visible = true
	process_mode = Node.PROCESS_MODE_INHERIT

	health_component.reset()
	TargetManager.register_target(self, [target_type])
