extends CharacterBody2D
class_name Mask

@export var mask_task: MaskTask.Type = MaskTask.Type.ChopWood
@export var color: Color = Color.WHITE
@export var mask_name: String = "Mask"
@export var movement_speed: float = 50.0
@export var attack: float = 5
@export var attack_speed: float = 1.0
@export var inventory_size: int = 1
@export var check_cooldown: float = 2.0

@onready var collision_shape: CollisionShape2D = $CollisionShape2D

var damage_timer: Timer
var check_timer: Timer

func _ready():
	apply_mask_properties()

	check_timer = Timer.new()
	check_timer.one_shot = false
	add_child(check_timer)

	damage_timer = Timer.new()
	damage_timer.one_shot = false
	add_child(damage_timer)

	abstract_ready()

func abstract_ready() -> void:
	return

func _physics_process(delta):
	abstract_physics_process(delta)

func abstract_physics_process(_delta) -> void:
	return

func apply_mask_properties():
	if not is_node_ready():
		return

func get_mask_task() -> MaskTask.Type:
	return mask_task

func get_mask_name() -> String:
	return mask_name
