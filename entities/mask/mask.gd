extends CharacterBody2D
class_name Mask

@export var mask_task: Enum.EntityType = Enum.EntityType.MaskLumberjack
@export var color: Color = Color.WHITE
@export var mask_name: String = "Mask"
@export var movement_speed: float = 50.0

@export var attack: float = 5
@export var attack_speed: float = 1.0
@export var attack_range: float = 15.0
@export var attack_distance: float = 30.0

@export var inventory_size: int = 1
@export var pickup_distance: float = 30.0
@export var target_search_cooldown: float = 0.5

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

func get_mask_task() -> Enum.EntityType:
	return mask_task

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

	velocity = direction * movement_speed
	move_and_slide()
