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

func _ready():
	super._ready()
	_on_mask_change(type)

	spawn_position = global_position

	respawn_timer = Timer.new()
	respawn_timer.one_shot = true
	respawn_timer.wait_time = respawn_cooldown
	add_child(respawn_timer)
	respawn_timer.timeout.connect(_on_respawn)

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

func _on_death(_die = false):
	super._on_death(false)
	respawn_timer.start()

	var tween: Tween = get_tree().create_tween()
	tween.tween_property(self, "rotation_degrees", rotation_degrees+80, 0.5) \
		.set_trans(Tween.TRANS_SINE) \
		.set_ease(Tween.EASE_IN)
	
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
