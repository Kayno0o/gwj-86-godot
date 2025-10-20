extends CollisionShape2D

@export var spawn_rate : int
@export var default_resource_count: int = 32

@export var tree: PackedScene
@export var rock: PackedScene
@export var wheat: PackedScene

@onready var spawn_area = $".".shape.extents
@onready var origin = $".".global_position -  spawn_area
@onready var world = get_tree().get_nodes_in_group("Master")[0]

@onready var timer: Timer = $Timer

func _ready() -> void:
	timer.start(spawn_rate)

	for x in default_resource_count: _spawn_random_resources()
	
func gen_random_pos():
	var x = randf_range(origin.x, spawn_area.x)
	var y = randf_range(origin.y, spawn_area.y)
	
	return Vector2(x, y)

func _spawn_random_resources():
	for i in world.difficulty:
		var ressource_instance
		var x = randi_range(0, 2)
		match x:
			0:
				ressource_instance = tree.instantiate()
			1:
				ressource_instance = rock.instantiate()
			2:
				ressource_instance = wheat.instantiate()
		ressource_instance.position = gen_random_pos()
		$"../../game".add_child(ressource_instance)

func _on_timer_timeout(): _spawn_random_resources()
