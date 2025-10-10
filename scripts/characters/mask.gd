extends CharacterBody2D
class_name Mask

@export var mask_task: MaskTask.Type = MaskTask.Type.ChopWood
@export var color: Color = Color.WHITE
@export var mask_name: String = "Mask"
@export var movement_speed: float = 50.0

@onready var collision_shape: CollisionShape2D = $CollisionShape2D

func _ready():
	apply_mask_properties()
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
